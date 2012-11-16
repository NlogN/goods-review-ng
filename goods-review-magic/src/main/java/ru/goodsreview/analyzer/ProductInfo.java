package ru.goodsreview.analyzer;


import org.json.JSONException;
import org.json.JSONObject;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;


/**
 * User: ilya
 * Date: 16.11.12
 */

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:beans.xml")
public class ProductInfo {

    @Autowired
    private JdbcTemplate jdbcTemplate;


    @Test
    public void test(){

        final String[] searchWords = {"6504630"};

        final List<JSONObject> searchResults = jdbcTemplate.query("SELECT ENTITY_ATTRS from ENTITY where ENTITY_TYPE_ID = 2 AND ENTITY_ATTRS like ?",
                new String[]{"%modelid=" + searchWords[0] + "%"},
                new RowMapper<JSONObject>() {
                    @Override
                    public JSONObject mapRow(ResultSet rs, int line) throws SQLException, DataAccessException {
                        try {
                            return new JSONObject(rs.getString("ENTITY_ATTRS"));
                        } catch (JSONException e) {
                            throw new RuntimeException(e);
                        }
                    }
                });

        for (JSONObject object1:searchResults){
            System.out.println(object1);
        }

    }
}