.PHONY: build publish ci_test clean test

build: test
	mvn package

clean:
	mvn clean

test: ci_test

# CircleCI test
ci_test: clean
	mvn test

# See https://bintray.com/lightstep for published artifacts
# You must have the following entry in your settings.xml of your .m2 directory
# This matches the distributionManagement/repository defined in the pom.xml
#
#    <server>
#        <id>lightstep-bintray</id>
#        <username>xxx</username>
#        <password>xxx</password>
#    </server>
#
publish: build
	@test -n "$$BINTRAY_USER" || (echo "BINTRAY_USER must be defined to publish" && false)
	@test -n "$$BINTRAY_API_KEY" || (echo "BINTRAY_API_KEY must be defined to publish" && false)
	@test -n "$$MAVEN_CENTRAL_USER_TOKEN" || (echo "MAVEN_CENTRAL_USER_TOKEN must be defined to publish" && false)
	@test -n "$$MAVEN_CENTRAL_TOKEN_PASSWORD" || (echo "MAVEN_CENTRAL_TOKEN_PASSWORD must be defined to publish" && false)
	@test -n "$$BINTRAY_GPG_PASSPHRASE" || (echo "$$BINTRAY_GPG_PASSPHRASE must be defined to publish" && false)

	@git diff-index --quiet HEAD || (echo "git has uncommitted changes. Refusing to publish." && false)
	#./inc-version.sh
	#mvn deploy

	curl -H "X-GPG-PASSPHRASE:$$$$BINTRAY_GPG_PASSPHRASE" -u $$BINTRAY_USER:$$BINTRAY_API_KEY -X POST https://api.bintray.com/gpg/lightstep/maven/java-common/versions/0.12.7