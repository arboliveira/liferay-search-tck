package com.liferay.portal.search.tck.bookmarks;

import org.arquillian.liferay.deploymentscenario.annotations.BndFile;

import com.liferay.portal.kernel.test.rule.Sync;
import com.liferay.portal.search.tck.bnd.BndConstants;

@BndFile(
		BndConstants.BASE_DIR 
		+ "/com/liferay/portal/search/tck/bookmarks"
		+ "/bnd.bnd")
@Sync
public class BookmarksFolderSearchTest 
	extends com.liferay.bookmarks.search.test.BookmarksFolderSearchTest {
	
}
