/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.model;

import cc.altius.FASP.framework.JsonDateDeserializer;
import cc.altius.FASP.framework.JsonDateSerializer;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import java.io.Serializable;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

/**
 *
 * @author akil
 */
public class Shipment extends BaseModel implements Serializable {

    private int shipmentId;
    private SimplePlanningUnitObject planningUnit;
    @JsonDeserialize(using = JsonDateDeserializer.class)
    @JsonSerialize(using = JsonDateSerializer.class)
    private Date expectedDeliveryDate;
    private double suggestedQty;
    private SimpleCodeObject procurementAgent;
    private SimpleObject procurementUnit;
    private SimpleObject supplier;
    private double quantity;
    private double rate;
    private double productCost;
    private String shipmentMode;
    private double freightCost;
    @JsonDeserialize(using = JsonDateDeserializer.class)
    @JsonSerialize(using = JsonDateSerializer.class)
    private Date orderedDate;
    @JsonDeserialize(using = JsonDateDeserializer.class)
    @JsonSerialize(using = JsonDateSerializer.class)
    private Date shippedDate;
    @JsonDeserialize(using = JsonDateDeserializer.class)
    @JsonSerialize(using = JsonDateSerializer.class)
    private Date receivedDate;
    private SimpleObject shipmentStatus;
    private String notes;
    private SimpleObject dataSource;
    private boolean accountFlag;
    private boolean erpFlag;
    private String orderNo;
    private String primeLineNo;
    private int versionId;
    private List<ShipmentBudget> shipmentBudgetList;

    public Shipment() {
        this.shipmentBudgetList = new LinkedList<>();
    }

    public Shipment(int shipmentId, SimplePlanningUnitObject planningUnit, Date expectedDeliveryDate, double suggestedQty, SimpleCodeObject procurementAgent, SimpleObject procurementUnit, SimpleObject supplier, double quantity, double rate, double productCost, String shipmentMode, double freightCost, Date orderedDate, Date shippedDate, Date receivedDate, SimpleObject shipmentStatus, String notes, SimpleObject dataSource, boolean accountFlag, boolean erpFlag, int versionId) {
        this.shipmentId = shipmentId;
        this.planningUnit = planningUnit;
        this.expectedDeliveryDate = expectedDeliveryDate;
        this.suggestedQty = suggestedQty;
        this.procurementAgent = procurementAgent;
        if (procurementUnit == null || procurementUnit.getId() == 0) {
            this.procurementUnit = null;
        } else {
            this.procurementUnit = procurementUnit;
        }
        if (supplier == null || supplier.getId() == 0) {
            this.supplier = null;
        } else {
            this.supplier = supplier;
        }
        this.quantity = quantity;
        this.rate = rate;
        this.productCost = productCost;
        this.shipmentMode = shipmentMode;
        this.freightCost = freightCost;
        this.orderedDate = orderedDate;
        this.shippedDate = shippedDate;
        this.receivedDate = receivedDate;
        this.shipmentStatus = shipmentStatus;
        this.notes = notes;
        this.dataSource = dataSource;
        this.accountFlag = accountFlag;
        this.erpFlag = erpFlag;
        this.versionId = versionId;
        this.shipmentBudgetList = new LinkedList<>();
    }

    public int getShipmentId() {
        return shipmentId;
    }

    public void setShipmentId(int shipmentId) {
        this.shipmentId = shipmentId;
    }

    public SimplePlanningUnitObject getPlanningUnit() {
        return planningUnit;
    }

    public void setPlanningUnit(SimplePlanningUnitObject planningUnit) {
        this.planningUnit = planningUnit;
    }

    public Date getExpectedDeliveryDate() {
        return expectedDeliveryDate;
    }

    public void setExpectedDeliveryDate(Date expectedDeliveryDate) {
        this.expectedDeliveryDate = expectedDeliveryDate;
    }

    public double getSuggestedQty() {
        return suggestedQty;
    }

    public void setSuggestedQty(double suggestedQty) {
        this.suggestedQty = suggestedQty;
    }

    public SimpleCodeObject getProcurementAgent() {
        return procurementAgent;
    }

    public void setProcurementAgent(SimpleCodeObject procurementAgent) {
        this.procurementAgent = procurementAgent;
    }

    public SimpleObject getProcurementUnit() {
        return procurementUnit;
    }

    public void setProcurementUnit(SimpleObject procurementUnit) {
        this.procurementUnit = procurementUnit;
    }

    public SimpleObject getSupplier() {
        return supplier;
    }

    public void setSupplier(SimpleObject supplier) {
        this.supplier = supplier;
    }

    public double getQuantity() {
        return quantity;
    }

    public void setQuantity(double quantity) {
        this.quantity = quantity;
    }

    public double getRate() {
        return rate;
    }

    public void setRate(double rate) {
        this.rate = rate;
    }

    public double getProductCost() {
        return productCost;
    }

    public void setProductCost(double productCost) {
        this.productCost = productCost;
    }

    public String getShipmentMode() {
        return shipmentMode;
    }

    public void setShipmentMode(String shipmentMode) {
        this.shipmentMode = shipmentMode;
    }

    public double getFreightCost() {
        return freightCost;
    }

    public void setFreightCost(double freightCost) {
        this.freightCost = freightCost;
    }

    public Date getOrderedDate() {
        return orderedDate;
    }

    public void setOrderedDate(Date orderedDate) {
        this.orderedDate = orderedDate;
    }

    public Date getShippedDate() {
        return shippedDate;
    }

    public void setShippedDate(Date shippedDate) {
        this.shippedDate = shippedDate;
    }

    public Date getReceivedDate() {
        return receivedDate;
    }

    public void setReceivedDate(Date receivedDate) {
        this.receivedDate = receivedDate;
    }

    public SimpleObject getShipmentStatus() {
        return shipmentStatus;
    }

    public void setShipmentStatus(SimpleObject shipmentStatus) {
        this.shipmentStatus = shipmentStatus;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public SimpleObject getDataSource() {
        return dataSource;
    }

    public void setDataSource(SimpleObject dataSource) {
        this.dataSource = dataSource;
    }

    public boolean isAccountFlag() {
        return accountFlag;
    }

    public void setAccountFlag(boolean accountFlag) {
        this.accountFlag = accountFlag;
    }

    public boolean isErpFlag() {
        return erpFlag;
    }

    public void setErpFlag(boolean erpFlag) {
        this.erpFlag = erpFlag;
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public String getPrimeLineNo() {
        return primeLineNo;
    }

    public void setPrimeLineNo(String primeLineNo) {
        this.primeLineNo = primeLineNo;
    }

    public int getVersionId() {
        return versionId;
    }

    public void setVersionId(int versionId) {
        this.versionId = versionId;
    }

    public List<ShipmentBudget> getShipmentBudgetList() {
        return shipmentBudgetList;
    }

    public void setShipmentBudgetList(List<ShipmentBudget> shipmentBudgetList) {
        this.shipmentBudgetList = shipmentBudgetList;
    }

    @Override
    public int hashCode() {
        int hash = 5;
        hash = 59 * hash + this.shipmentId;
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
        final Shipment other = (Shipment) obj;
        if (this.shipmentId != other.shipmentId) {
            return false;
        }
        return true;
    }

}
