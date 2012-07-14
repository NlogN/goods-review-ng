package ru.goodsreview.core.model.impl.json;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import ru.goodsreview.core.db.entity.EntityType;
import ru.goodsreview.core.model.Review;
import ru.goodsreview.core.model.Thesis;
import ru.goodsreview.core.util.DateUtil;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static ru.goodsreview.core.util.JSONUtil.unsafeGetString;

/**
 * User: daddy-bear
 * Date: 14.07.12
 * Time: 14:39
 */
public class ReviewOverJson implements Review {

    private final JSONObject jsonObject;

    public ReviewOverJson(final JSONObject jsonObject) {
        this.jsonObject = jsonObject;
    }

    @Override
    public String getPro() {
        return unsafeGetString(jsonObject, "pro");
    }

    @Override
    public String getContra() {
        return unsafeGetString(jsonObject, "contra");
    }

    @Override
    public String getText() {
        return unsafeGetString(jsonObject, "text");
    }

    @Override
    public int getGrade() {
        return Integer.parseInt(unsafeGetString(jsonObject, "grade"));
    }

    @Override
    public int getAgree() {
        return Integer.parseInt(unsafeGetString(jsonObject, "agree"));
    }

    @Override
    public int getReject() {
        return Integer.parseInt(unsafeGetString(jsonObject, "reject"));
    }

    @Override
    public Date getDate() {
        return DateUtil.parseFromBaseFormat(unsafeGetString(jsonObject, "date"));
    }

    @Override
    public long getId() {
        return Long.parseLong(unsafeGetString(jsonObject, "id"));
    }

    @Override
    public long getModelId() {
        return Long.parseLong(unsafeGetString(jsonObject, "modelId"));
    }

    @Override
    public List<Thesis> getThesises() {
        final List<Thesis> thesises = new ArrayList<Thesis>();

        if (jsonObject.has("thesises")) {
            try {
                JSONArray thesisArray = jsonObject.getJSONArray("thesises");
                for (int i = 0; i < thesisArray.length(); i++) {
                    thesises.add(new ThesisOverJson(thesisArray.getJSONObject(i)));
                }
            } catch (JSONException e) {
                throw new RuntimeException(e);
            }
        }

        return thesises;
    }
}