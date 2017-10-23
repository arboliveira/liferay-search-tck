#!/bin/sh

set -o errexit ; set -o nounset

RUN_ALL_TESTS=true
REDEPLOY_ALL_DEPENDENCIES=false
JOURNAL_IN_SPLITREPO=false
DDM_IN_SPLITREPO=false


#
# SEE: com.liferay.portal.search.tck.AllSearchTestsArquillian
#
function run_all_tests()
{
test_run foundation/portal-search/portal-search-test \
	com.liferay.portal.search.document.test.DocumentTest \
	com.liferay.portal.search.facet.faceted.searcher.test.AssetEntriesFacetedSearcherTest \
	com.liferay.portal.search.facet.faceted.searcher.test.AssetEntriesStatusFacetedSearcherTest \
	com.liferay.portal.search.facet.faceted.searcher.test.AssetEntriesVersionFacetedSearcherTest \
	com.liferay.portal.search.facet.faceted.searcher.test.AssetTagNamesFacetedSearcherTest \
	com.liferay.portal.search.facet.faceted.searcher.test.CalendarFacetedSearcherTest \
	com.liferay.portal.search.facet.faceted.searcher.test.FacetedSearcherTest \
	com.liferay.portal.search.facet.faceted.searcher.test.ModifiedFacetedSearcherTest \
	com.liferay.portal.search.facet.faceted.searcher.test.PermissionFilterFacetedSearcherTest \
	com.liferay.portal.search.facet.faceted.searcher.test.ScopeFacetedSearcherTest \
	com.liferay.portal.search.facet.faceted.searcher.test.SearchPermissionCheckerFacetedSearcherTest \
	com.liferay.portal.search.facet.faceted.searcher.test.UserFacetedSearcherTest \
	com.liferay.portal.search.indexer.test.IndexerPostProcessorRegistryTest \
	com.liferay.portal.search.internal.test.SearchPermissionCheckerTest \
	com.liferay.portal.search.pagination.test.SearchPaginationTest \
	com.liferay.expando.search.test.ExpandoSearchTest

test_run foundation/user-groups-admin/user-groups-admin-test \
	com.liferay.user.groups.admin.web.internal.search.test.UserGroupIndexerTest 

test_run foundation/users-admin/users-admin-test \
	com.liferay.users.admin.indexer.test.UserIndexerTest \
	com.liferay.users.admin.indexer.test.OrganizationIndexerTest

test_run collaboration/blogs/blogs-test \
	com.liferay.blogs.asset.test.BlogsEntryAssetSearchTest \
	com.liferay.blogs.search.test.BlogsEntrySearchTest \
	com.liferay.blogs.service.test.BlogsEntryStatusTransitionTest

test_run collaboration/bookmarks/bookmarks-test \
	com.liferay.bookmarks.search.test.BookmarksEntrySearchTest \
	com.liferay.bookmarks.search.test.BookmarksFolderSearchTest \
	com.liferay.bookmarks.service.test.BookmarksFolderServiceTest

test_run collaboration/wiki/wiki-test \
	com.liferay.wiki.search.test.WikiPageSearchTest \
	com.liferay.wiki.search.test.WikiPageTitleSearcherTest

test_run forms-and-workflow/calendar/calendar-test \
	com.liferay.calendar.search.test.CalendarBookingIndexerTest \
	com.liferay.calendar.search.test.CalendarSearcherTest

test_run collaboration/document-library/document-library-test \
	com.liferay.document.library.search.test.DLFileEntrySearchTest

test_run forms-and-workflow/dynamic-data-lists/dynamic-data-lists-test \
	com.liferay.dynamic.data.lists.search.test.DDLRecordSearchTest

test_run web-experience/asset/asset-test \
	com.liferay.asset.search.test.*Test \
	com.liferay.asset.util.test.AssetUtilTest

test_run_journal \
	com.liferay.journal.asset.test.JournalArticleAssetSearchTest \
	com.liferay.journal.search.test.JournalArticleIndexableTest \
	com.liferay.journal.search.test.JournalArticleIndexerLocalizedContentTest \
	com.liferay.journal.search.test.JournalArticleSearchTest \
	com.liferay.journal.search.test.JournalFolderSearchTest \
	com.liferay.journal.search.test.JournalIndexerTest \
	com.liferay.journal.service.test.JournalArticleIndexVersionsTest
}

function run_some_tests()
{
#	

if [ 0 = true ]
then

test_run adaptive-media/adaptive-media-image-impl-test \
	com.liferay.adaptive.media.image.internal.test.AdaptiveMediaImageDeleteConfigurationTest

# this test creates a DL file and never removes it -- search engine is polluted
test_run collaboration/document-library/document-library-test \
	com.liferay.document.library.webdav.test.WebDAVLitmusBasicTest

#
:
fi

#
:	
}

function ant_deploy()
{
	local subdir=$1

	figlet -f mini ant deploy $1 || true

	cd ${LIFERAY_PORTAL_DIR}/$subdir
	ant deploy install-portal-snapshot
}

function gradle_deploy()
{
	local subdir=$1

	figlet -f mini gradle deploy $1 || true

	cd ${LIFERAY_PORTAL_DIR}/$subdir
	${LIFERAY_PORTAL_DIR}/gradlew deploy
}

function do_test_run()
{
	local directory=$1
	local no_settings_gradle=$2
	shift 2
	local tests=( "$@" ) 

	figlet -f digital RUN $directory || true

	cd $directory

	if [ "$no_settings_gradle" = true ]
	then
		mv settings.gradle settings.gradle.ORIGINAL || true
		mv ../settings.gradle ../settings.gradle.ORIGINAL || true
	fi

	local gwtests=()
	for test in "${tests[@]}"; do
		gwtests+=("--tests")
		gwtests+=($test)
	done

	${LIFERAY_PORTAL_DIR}/gradlew testIntegration --stacktrace "${gwtests[@]}" || { 
		RETURN_CODE=$?
		echo ${RETURN_CODE}
		echo "*** IGNORING BOGUS FAILURE & MOVING ON! :-)"
	}

	if [ "$no_settings_gradle" = true ]
	then
		mv settings.gradle.ORIGINAL settings.gradle || true
		mv ../settings.gradle.ORIGINAL ../settings.gradle || true	
	fi

	open build/reports/tests/testIntegration/index.html || true
}

function test_run()
{
	local subdir=$1
	shift 1
	local tests=( "$@" ) 

	local directory=${LIFERAY_PORTAL_DIR}/modules/apps/$subdir
	local no_settings_gradle=true

	do_test_run $directory $no_settings_gradle "${tests[@]}"
}

function test_run_splitrepo()
{
	local splitrepo=$1
	shift 1
	local tests=( "$@" ) 

	local directory=${LIFERAY_PORTAL_DIR}/../$splitrepo
	local no_settings_gradle=false

	do_test_run $directory $no_settings_gradle "${tests[@]}"
}

function test_run_journal()
{
	local tests=( "$@" ) 

if [ "$JOURNAL_IN_SPLITREPO" = true ]
then

test_run_splitrepo com-liferay-journal/journal-test "${tests[@]}"

else

test_run web-experience/journal/journal-test "${tests[@]}"

fi

}

function test_run_ddm()
{
	local tests=( "$@" ) 

if [ "$DDM_IN_SPLITREPO" = true ]
then

test_run_splitrepo com-liferay-dynamic-data-mapping/dynamic-data-mapping-test "${tests[@]}"

else

test_run forms-and-workflow/dynamic-data-mapping/dynamic-data-mapping-test "${tests[@]}"

fi

}

function redeploy_all_dependencies() 
{
ant_deploy portal-kernel
ant_deploy portal-test
ant_deploy portal-test-integration
gradle_deploy modules/apps/forms-and-workflow/dynamic-data-mapping/dynamic-data-mapping-test-util
}

function main() 
{

if [ "$REDEPLOY_ALL_DEPENDENCIES" = true ] 
then
	redeploy_all_dependencies
fi

if [ "$RUN_ALL_TESTS" = true ]
then
	run_all_tests
else
	run_some_tests
fi

}


						main