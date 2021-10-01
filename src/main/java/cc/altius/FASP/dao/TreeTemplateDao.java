/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.dao;

import cc.altius.FASP.model.CustomUserDetails;
import cc.altius.FASP.model.TreeNode;
import cc.altius.FASP.model.TreeTemplate;
import cc.altius.utils.TreeUtils.Tree;
import java.util.List;
import java.util.Map;

/**
 *
 * @author akil
 */
public interface TreeTemplateDao {

    public List<TreeTemplate> getTreeTemplateList(CustomUserDetails curUser);
    
    public TreeTemplate getTreeTemplateById(int treeTemplateId, CustomUserDetails curUser);

    public Tree<TreeNode> getTree(int treeTemplateId);

    public Map<String, Object> getConsumption(int treeTemplateId);
}
