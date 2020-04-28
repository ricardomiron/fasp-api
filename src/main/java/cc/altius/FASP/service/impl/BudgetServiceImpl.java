/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.service.impl;

import cc.altius.FASP.dao.BudgetDao;
import cc.altius.FASP.dao.FundingSourceDao;
import cc.altius.FASP.model.CustomUserDetails;
import cc.altius.FASP.model.Budget;
import cc.altius.FASP.model.FundingSource;
import cc.altius.FASP.model.Realm;
import cc.altius.FASP.service.AclService;
import cc.altius.FASP.service.BudgetService;
import cc.altius.FASP.service.RealmService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

/**
 *
 * @author akil
 */
@Service
public class BudgetServiceImpl implements BudgetService {

    @Autowired
    private BudgetDao budgetDao;
    @Autowired
    private FundingSourceDao fundingSourceDao;
    @Autowired
    private RealmService realmService;
    @Autowired
    private AclService aclService;

    @Override
    public int addBudget(Budget b, CustomUserDetails curUser) {
        FundingSource fs = this.fundingSourceDao.getFundingSourceById(b.getFundingSource().getFundingSourceId(), curUser);
        if (this.aclService.checkRealmAccessForUser(curUser, fs.getRealm().getId())) {
            return this.budgetDao.addBudget(b, curUser);
        } else {
            throw new AccessDeniedException("Access denied");
        }
    }

    @Override
    public int updateBudget(Budget b, CustomUserDetails curUser) {
        Budget bt = this.budgetDao.getBudgetById(b.getBudgetId(), curUser);
        if (this.aclService.checkRealmAccessForUser(curUser, bt.getFundingSource().getRealm().getId())) {
            return this.budgetDao.updateBudget(b, curUser);
        } else {
            throw new AccessDeniedException("Access denied");
        }
    }

    @Override
    public List<Budget> getBudgetList(CustomUserDetails curUser) {
        return this.budgetDao.getBudgetList(curUser);
    }

    @Override
    public List<Budget> getBudgetListForRealm(int realmId, CustomUserDetails curUser) {
        Realm r = this.realmService.getRealmById(realmId, curUser);
        if (this.aclService.checkRealmAccessForUser(curUser, realmId)) {
            return this.budgetDao.getBudgetListForRealm(realmId, curUser);
        } else {
            throw new AccessDeniedException("Access denied");
        }
    }

    @Override
    public Budget getBudgetById(int BudgetId, CustomUserDetails curUser) {
        return this.budgetDao.getBudgetById(BudgetId, curUser);
    }

    @Override
    public List<Budget> getBudgetListForSync(String lastSyncDate, CustomUserDetails curUser) {
        return this.budgetDao.getBudgetListForSync(lastSyncDate, curUser);
    }

}
