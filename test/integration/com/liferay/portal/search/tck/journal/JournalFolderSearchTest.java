package com.liferay.portal.search.tck.journal;

import org.arquillian.liferay.deploymentscenario.annotations.BndFile;

import com.liferay.portal.search.tck.bnd.BndConstants;

@BndFile(
		BndConstants.BASE_DIR 
		+ "/com/liferay/portal/search/tck/journal"
		+ "/bnd.bnd")
public class JournalFolderSearchTest 
	extends com.liferay.journal.search.test.JournalFolderSearchTest{

}
