#!/bin/sh

set -o errexit ; set -o nounset



function ant_deploy()
{
	subdir=$1
	cd ${LIFERAY_PORTAL_DIR}/$subdir
	ant deploy
}

function ant_test_prepare()
{
	subdir=$1
	cd ${LIFERAY_PORTAL_DIR}/$subdir
	ant test-integration -Djunit.jvm=BOGUS || { 
		RETURN_CODE=$?
		echo ${RETURN_CODE}
		echo "*** IGNORING ANT FAILURE & MOVING ON! :-)"
	}
}


ant_deploy portal-test
ant_deploy portal-test-internal

ant_deploy modules/apps/dynamic-data-mapping/dynamic-data-mapping-test-util

ant_test_prepare modules/apps/bookmarks/bookmarks-test
ant_test_prepare modules/apps/document-library/document-library-test
ant_test_prepare modules/apps/dynamic-data-lists/dynamic-data-lists-test
ant_test_prepare modules/apps/journal/journal-test
ant_test_prepare modules/apps/wiki/wiki-test
