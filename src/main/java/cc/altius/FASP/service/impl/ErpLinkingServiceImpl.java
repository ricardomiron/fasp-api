/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.service.impl;

import cc.altius.FASP.dao.ErpLinkingDao;
import cc.altius.FASP.model.CustomUserDetails;
import cc.altius.FASP.model.DTO.ARTMISHistoryDTO;
import cc.altius.FASP.model.DTO.ERPNotificationDTO;
import cc.altius.FASP.model.DTO.ErpOrderAutocompleteDTO;
import cc.altius.FASP.model.DTO.ManualTaggingDTO;
import cc.altius.FASP.model.DTO.ManualTaggingOrderDTO;
import cc.altius.FASP.model.DTO.NotificationSummaryDTO;
import cc.altius.FASP.model.erpLinking.ErpShipmentsOutput;
import cc.altius.FASP.model.erpLinking.QatErpLinkedShipmentsInput;
import cc.altius.FASP.service.ErpLinkingService;
import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 *
 * @author akil
 */
@Service
public class ErpLinkingServiceImpl implements ErpLinkingService {

    @Autowired
    private ErpLinkingDao erpLinkingDao;

    @Override
    public ManualTaggingDTO getShipmentDetailsByParentShipmentId(int parentShipmentId) {
        return this.erpLinkingDao.getShipmentDetailsByParentShipmentId(parentShipmentId);
    }

    @Override
    public List<ManualTaggingDTO> getOrderDetailsByForNotLinkedERPShipments(String roNoOrderNo, int planningUnitId, int linkingType) {
        return this.erpLinkingDao.getOrderDetailsByForNotLinkedERPShipments(roNoOrderNo, planningUnitId, linkingType);
    }

    @Override
    public int createERPNotification(String orderNo, int primeLineNo, int shipmentId, int notificationTypeId) {
        return this.erpLinkingDao.createERPNotification(orderNo, primeLineNo, shipmentId, notificationTypeId);
    }

    @Override
    public List<ERPNotificationDTO> getNotificationList(ERPNotificationDTO eRPNotificationDTO) {
        return this.erpLinkingDao.getNotificationList(eRPNotificationDTO);
    }

    @Override
    public int updateNotification(ERPNotificationDTO eRPNotificationDTO, CustomUserDetails curUser) {
        return this.erpLinkingDao.updateNotification(eRPNotificationDTO, curUser);
    }

    @Override
    public int getNotificationCount(CustomUserDetails curUser) {
        return this.erpLinkingDao.getNotificationCount(curUser);
    }

    @Override
    public List<ARTMISHistoryDTO> getARTMISHistory(String orderNo, int primeLineNo) {
        return this.erpLinkingDao.getARTMISHistory(orderNo, primeLineNo);
    }

    @Override
    public int checkPreviousARTMISPlanningUnitId(String orderNo, int primeLineNo) {
        return this.erpLinkingDao.checkPreviousARTMISPlanningUnitId(orderNo, primeLineNo);
    }

    @Override
    public List<NotificationSummaryDTO> getNotificationSummary(CustomUserDetails curUser) {
        return this.erpLinkingDao.getNotificationSummary(curUser);
    }

    @Override
    public List<ErpOrderAutocompleteDTO> getErpOrderSearchData(String term, int programId, int planningUnitId, int linkingType) {
        return this.erpLinkingDao.getErpOrderSearchData(term, programId, planningUnitId, linkingType);
    }

    @Override
    public List<ManualTaggingDTO> getShipmentListForManualTagging(ManualTaggingDTO manualTaggingDTO, CustomUserDetails curUser) {
        return this.erpLinkingDao.getShipmentListForManualTagging(manualTaggingDTO, curUser);
    }

    @Override
    public List<ManualTaggingOrderDTO> getOrderDetailsByOrderNoAndPrimeLineNo(String roNoOrderNo, int programId, int planningUnitId, int linkingType, int parentShipmentId) {
        return this.erpLinkingDao.getOrderDetailsByOrderNoAndPrimeLineNo(roNoOrderNo, programId, planningUnitId, linkingType, parentShipmentId);
    }

    @Override
    public List<Integer> linkShipmentWithARTMIS(ManualTaggingOrderDTO[] manualTaggingOrderDTO, CustomUserDetails curUser) {
        try {
            List<Integer> result = new ArrayList<>();
            System.out.println("length---" + manualTaggingOrderDTO.length);
            for (int i = 0; i < manualTaggingOrderDTO.length; i++) {
                System.out.println("manualTaggingOrderDTO[i]---" + manualTaggingOrderDTO[i]);
                if (manualTaggingOrderDTO[i].isActive()) {
                    int id = 0;
                    int count = this.erpLinkingDao.checkIfOrderNoAlreadyTagged(manualTaggingOrderDTO[i].getOrderNo(), manualTaggingOrderDTO[i].getPrimeLineNo());
                    if (manualTaggingOrderDTO[i].getShipmentId() != 0) {
                        if (count != 0) {
                            id = this.erpLinkingDao.updateERPLinking(manualTaggingOrderDTO[i], curUser);
                        } else {
                            id = this.erpLinkingDao.linkShipmentWithARTMIS(manualTaggingOrderDTO[i], curUser);
                        }
                    } else {
                        if (count == 0) {
                            id = this.erpLinkingDao.linkShipmentWithARTMISWithoutShipmentid(manualTaggingOrderDTO[i], curUser);
                        }
                    }
                    result.add(id);
                } else if (!manualTaggingOrderDTO[i].isActive()) {
                    System.out.println("****************************************************************************************" + manualTaggingOrderDTO[i]);
                    this.erpLinkingDao.delinkShipment(manualTaggingOrderDTO[i], curUser);
                }
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<ManualTaggingDTO> getShipmentListForDelinking(int programId, int planningUnitId) {
        return this.erpLinkingDao.getShipmentListForDelinking(programId, planningUnitId);
    }

    @Override
    public List<ManualTaggingDTO> getNotLinkedShipments(int programId, int linkingTypeId) {
        return this.erpLinkingDao.getNotLinkedShipments(programId, linkingTypeId);
    }

    @Override
    public void delinkShipment(ManualTaggingOrderDTO erpOrderDTO, CustomUserDetails curUser) {
        this.erpLinkingDao.delinkShipment(erpOrderDTO, curUser);
    }

    // ################################## New functions ###########################################
    @Override
    public List<ErpShipmentsOutput> getQatErpLinkedShipments(QatErpLinkedShipmentsInput input, CustomUserDetails curUser) {
        return this.erpLinkingDao.getQatErpLinkedShipments(input, curUser);
    }

}
