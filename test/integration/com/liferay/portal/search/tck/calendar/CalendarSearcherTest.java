package com.liferay.portal.search.tck.calendar;

import org.arquillian.liferay.deploymentscenario.annotations.BndFile;

import com.liferay.portal.kernel.test.rule.Sync;
import com.liferay.portal.search.tck.bnd.BndConstants;

@BndFile(
		BndConstants.BASE_DIR 
		+ "/com/liferay/portal/search/tck/calendar"
		+ "/bnd.bnd")
@Sync
public class CalendarSearcherTest 
	extends com.liferay.calendar.search.test.CalendarSearcherTest {

}
