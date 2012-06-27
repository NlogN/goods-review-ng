package ru.goodsreview.scheduler.database.controllers;

import org.springframework.beans.factory.annotation.Required;
import org.springframework.jdbc.core.JdbcTemplate;
import ru.goodsreview.scheduler.TaskParameters;
import ru.goodsreview.scheduler.database.mappers.TaskMapper;

import java.util.List;

/**
 * User: achugr
 * Date: 26.06.12
 * Email: achugr@yandex-team.ru
 */
public class TaskDbController {
    private JdbcTemplate jdbcTemplate;

    public TaskDbController(JdbcTemplate jdbcTemplate){
        this.jdbcTemplate = jdbcTemplate;
    }

    @Required
    public void setJdbcTemplate(JdbcTemplate jdbcTemplate){
        this.jdbcTemplate = jdbcTemplate;
    }

    public void updateLastRunTime(long lastRunTime){
        jdbcTemplate.update("update task set last_run = ?", lastRunTime);
    }

    public void updateLastPingTime(long id){
        jdbcTemplate.update("update task set last_ping = ? ", id);
    }

    public List urgentTasks(){
        long currentTime = System.currentTimeMillis();
        return jdbcTemplate.query("select id, bean_name, params from task where (? - last_run < scheduling_time) ", new Object[]{currentTime}, new TaskMapper());
    }

}
