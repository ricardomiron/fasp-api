/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.model;

import java.io.Serializable;
import java.util.Date;

/**
 *
 * @author akil
 */
public class ShipmentBatchInfo implements Serializable {

    private int shipmentTransBatchInfoId;
    private String batchNo;
    private Date expiryDate;
    private int quantity;

    public int getShipmentTransBatchInfoId() {
        return shipmentTransBatchInfoId;
    }

    public void setShipmentTransBatchInfoId(int shipmentTransBatchInfoId) {
        this.shipmentTransBatchInfoId = shipmentTransBatchInfoId;
    }

    public String getBatchNo() {
        return batchNo;
    }

    public void setBatchNo(String batchNo) {
        this.batchNo = batchNo;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 79 * hash + this.shipmentTransBatchInfoId;
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final ShipmentBatchInfo other = (ShipmentBatchInfo) obj;
        if (this.shipmentTransBatchInfoId != other.shipmentTransBatchInfoId) {
            return false;
        }
        return true;
    }
}
