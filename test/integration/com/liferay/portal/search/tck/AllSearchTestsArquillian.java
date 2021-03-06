/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.liferay.portal.search.tck;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

/**
 * @see search-tck/sh/arquillian-search-tests-run-all.sh
 *
 * @author André de Oliveira
 */
@RunWith(Suite.class)
@SuiteClasses( {
	com.liferay.portal.search.facet.faceted.searcher.test.AssetTagNamesFacetTest.class,
	com.liferay.portal.search.facet.faceted.searcher.test.FacetedSearcherTest.class,
	com.liferay.portal.search.facet.faceted.searcher.test.ModifiedFacetTest.class,
	com.liferay.portal.search.facet.faceted.searcher.test.ScopeFacetTest.class,
	com.liferay.portal.search.indexer.test.IndexerPostProcessorRegistryTest.class,
	com.liferay.portal.search.internal.test.SearchPermissionCheckerTest.class,

	com.liferay.users.admin.indexer.test.UserIndexerTest.class,

	com.liferay.blogs.asset.test.BlogsEntryAssetSearchTest.class,
	com.liferay.blogs.search.test.BlogsEntrySearchTest.class,
	com.liferay.blogs.service.test.BlogsEntryStatusTransitionTest.class,

	com.liferay.bookmarks.search.test.BookmarksEntrySearchTest.class,
	com.liferay.bookmarks.search.test.BookmarksFolderSearchTest.class,
	com.liferay.bookmarks.service.test.BookmarksFolderServiceTest.class,

	com.liferay.calendar.search.test.CalendarBookingIndexerTest.class,
	com.liferay.calendar.search.test.CalendarSearcherTest.class,

	com.liferay.document.library.search.test.DLFileEntrySearchTest.class,

	com.liferay.dynamic.data.lists.search.test.DDLRecordSearchTest.class,

	com.liferay.journal.asset.test.JournalArticleAssetSearchTest.class,
	com.liferay.journal.search.test.JournalArticleIndexableTest.class,
	com.liferay.journal.search.test.JournalArticleIndexerLocalizedContentTest.class,
	com.liferay.journal.search.test.JournalArticleSearchTest.class,
	com.liferay.journal.search.test.JournalFolderSearchTest.class,
	com.liferay.journal.search.test.JournalIndexerTest.class,
	com.liferay.journal.service.test.JournalArticleIndexVersionsTest.class,

	com.liferay.wiki.search.test.WikiPageSearchTest.class,
	com.liferay.wiki.search.test.WikiPageTitleSearcherTest.class,
})
public class AllSearchTestsArquillian {

}