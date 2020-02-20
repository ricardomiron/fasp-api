/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.model.rowMapper;

import cc.altius.FASP.model.DataSource;
import cc.altius.FASP.model.DataSourceType;
import cc.altius.FASP.model.Label;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.springframework.jdbc.core.RowMapper;

/**
 *
 * @author palash
 */
public class DataSourceRowMapper implements RowMapper<DataSource> {

    @Override
    public DataSource mapRow(ResultSet rs, int i) throws SQLException {
        DataSource ds = new DataSource();
        ds.setDataSourceId(rs.getInt("DATA_SOURCE_ID"));
        ds.setActive(rs.getBoolean("ACTIVE"));
        DataSourceType dst = new DataSourceType();
        dst.setDataSourceTypeId(rs.getInt("DATA_SOURCE_TYPE_ID"));
        ds.setDataSourceType(dst);
        Label l = new Label();
        l.setEngLabel(rs.getString("LABEL_EN"));
        l.setFreLabel(rs.getString("LABEL_FR"));
        l.setSpaLabel(rs.getString("LABEL_SP"));
        l.setPorLabel(rs.getString("LABEL_PR"));
        l.setLabelId(rs.getInt("LABEL_ID"));
        
        ds.setLabel(l);
        return ds;
    }

}
