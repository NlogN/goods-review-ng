package ru.goodsreview.analyzer.util.dictionary;

import java.util.HashSet;
import java.util.Set;

/**
 * Date: 18.07.12
 * Time: 18:20
 * Author:
 * Ilya Makeev
 * ilya.makeev@gmail.com
 */

//TODO утилитные классы всегда имеют приватный конструктор и являются абстрактными или файнал
public class ObserveDict {
    //TODO java6 style
    private final static HashSet<String> dictionary = new HashSet();

    static {
        dictionary.add("не");
        dictionary.add("более");
        dictionary.add("достаточно");
        dictionary.add("очень");
        dictionary.add("слишком");
        dictionary.add("довольно");
    }


    public static Set<String> getDictionary() {
        return dictionary;
    }

}
