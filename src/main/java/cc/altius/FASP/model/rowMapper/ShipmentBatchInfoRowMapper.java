/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.model.rowMapper;

import cc.altius.FASP.model.ShipmentBatchInfo;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.springframework.jdbc.core.RowMapper;

/**
 *
 * @author akil
 */
public class ShipmentBatchInfoRowMapper implements RowMapper<ShipmentBatchInfo> {

    @Override
    public ShipmentBatchInfo mapRow(ResultSet rs, int i) throws SQLException {
        ShipmentBatchInfo sb = new ShipmentBatchInfo();
        sb.setShipmentTransBatchInfoId(rs.getInt("SHIPMENT_TRANS_BATCH_INFO_ID"));
        if (rs.wasNull()) {
            return null;
        }
        sb.setBatchNo(rs.getString("BATCH_NO"));
        sb.setExpiryDate(rs.getDate("EXPIRY_DATE"));
        sb.setQuantity(rs.getInt("BATCH_QTY"));
        return sb;
    }

}
