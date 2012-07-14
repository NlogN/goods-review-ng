package ru.goodsreview.core.model;

import java.util.Date;

/**
 * User: daddy-bear
 * Date: 14.07.12
 * Time: 14:34
 */
public interface Review {

    String getPro();

    String getContra();

    String getText();

    int getGrade();

    int getAgree();

    int getReject();

    Date getDate();

    long getId();

    long getModelId();

    //TODO extracted facts

}
