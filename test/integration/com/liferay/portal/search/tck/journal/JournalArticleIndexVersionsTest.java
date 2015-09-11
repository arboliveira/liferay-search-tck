package com.liferay.portal.search.tck.journal;

import org.arquillian.liferay.deploymentscenario.annotations.BndFile;

import com.liferay.portal.kernel.test.rule.Sync;
import com.liferay.portal.search.tck.bnd.BndConstants;

@BndFile(
		BndConstants.BASE_DIR 
		+ "/com/liferay/portal/search/tck/journal"
		+ "/bnd.bnd")
@Sync
public class JournalArticleIndexVersionsTest 
	extends com.liferay.journal.service.test.JournalArticleIndexVersionsTest{
	
}
