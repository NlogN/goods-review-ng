package ru.goodsreview.analyzer;
/**
 * Date: 18.07.12
 * Time: 03:20
 * Author:
 * Ilya Makeev
 * ilya.makeev@gmail.com
 */
import ru.goodsreview.analyzer.util.sentence.ReviewTokens;
import ru.goodsreview.analyzer.word.analyzer.MystemAnalyzer;
import ru.goodsreview.analyzer.word.analyzer.ReportAnalyzer;
import junit.framework.TestCase;
import junit.framework.TestSuite;
import junit.textui.TestRunner;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

public class TestClass extends TestCase {

    public TestClass(String testName) {
        super(testName);
    }

    public void testMystemAnalyzer() throws UnsupportedEncodingException {
        String s = "телефоном{телефон=S,муж,неод=твор,ед}";
        String report = MystemAnalyzer.getInstance().report("телефоном");
        assertTrue(report.equals(s));
    }
    
    public void testReportList() throws UnsupportedEncodingException {
        String s = "сборки{сборка=S,жен,неод=(им,мн|род,ед|вин,мн)}";
        ArrayList<String> reportList = ReportAnalyzer.buildReportList(s);
        assertTrue(reportList.size()==3);
    }

//    public void testFeatureDictionary() throws UnsupportedEncodingException {
//        Object [] arr = ReviewTokens.getFeatureDictionary().getDictionary().toArray();
//            assertTrue(MystemAnalyzer.isRussianWord(arr[0].toString()));
//    }

    public void testOpinionDictionary() throws UnsupportedEncodingException {
        Object[] arr = ReviewTokens.getMapDictionary().getDictionary().keySet().toArray();
        assertTrue(MystemAnalyzer.isRussianWord(arr[0].toString()));
    }

    public static void main(String[] args) {
        TestRunner runner = new TestRunner();
        TestSuite suite = new TestSuite();
        suite.addTest(new TestClass("testReportList"));
        suite.addTest(new TestClass("testMystemAnalyzer"));
       // suite.addTest(new TestClass("testFeatureDictionary"));
        suite.addTest(new TestClass("testOpinionDictionary"));
        runner.doRun(suite);
    }
}