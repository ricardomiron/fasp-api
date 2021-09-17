/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.service.impl;

import cc.altius.FASP.dao.UsageTemplateDao;
import cc.altius.FASP.model.CustomUserDetails;
import cc.altius.FASP.model.UsageTemplate;
import cc.altius.FASP.service.UsageTemplateService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 *
 * @author akil
 */
@Service
public class UsageTemplateServiceImpl implements UsageTemplateService {

    @Autowired
    private UsageTemplateDao usageTemplateDao;

    @Override
    public List<UsageTemplate> getUsageTemplateList(boolean active, CustomUserDetails curUser) {
        return this.usageTemplateDao.getUsageTemplateList(active, curUser);
    }

    @Override
    public int addAndUpdateUsageTemplate(List<UsageTemplate> usageTemplateList, CustomUserDetails curUser) {
        return this.usageTemplateDao.addAndUpdateUsageTemplate(usageTemplateList, curUser);
    }

}
