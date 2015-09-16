#!/bin/sh

set -o errexit ; set -o nounset



function ant_deploy()
{
	subdir=$1
	cd ${LIFERAY_PORTAL_DIR}/$subdir
	ant deploy
}

function gradle_deploy()
{
	subdir=$1
	cd ${LIFERAY_PORTAL_DIR}/$subdir
	${LIFERAY_PORTAL_DIR}/gradlew deploy
}

function test_prepare()
{
	subdir=$1
	cd ${LIFERAY_PORTAL_DIR}/$subdir
	${LIFERAY_PORTAL_DIR}/gradlew testIntegration -Djunit.jvm=BOGUS || { 
		RETURN_CODE=$?
		echo ${RETURN_CODE}
		echo "*** IGNORING ANT FAILURE & MOVING ON! :-)"
	}
}


ant_deploy portal-test
ant_deploy portal-test-internal

gradle_deploy modules/apps/dynamic-data-mapping/dynamic-data-mapping-test-util

test_prepare modules/apps/bookmarks/bookmarks-test
test_prepare modules/apps/document-library/document-library-test
test_prepare modules/apps/dynamic-data-lists/dynamic-data-lists-test
test_prepare modules/apps/journal/journal-test
test_prepare modules/apps/wiki/wiki-test
