/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.model;

import java.io.Serializable;

/**
 *
 * @author akil
 */
public class Problem extends BaseModel implements Serializable {

    private int problemId;
    private Label label;
    private String actionUrl;

    public Problem() {
    }

    public Problem(int problemId, Label label, String actionUrl) {
        this.problemId = problemId;
        this.label = label;
        this.actionUrl = actionUrl;
        setActive(true);
    }

    public int getProblemId() {
        return problemId;
    }

    public void setProblemId(int problemId) {
        this.problemId = problemId;
    }

    public Label getLabel() {
        return label;
    }

    public void setLabel(Label label) {
        this.label = label;
    }

    public String getActionUrl() {
        return actionUrl;
    }

    public void setActionUrl(String actionUrl) {
        this.actionUrl = actionUrl;
    }
    
    
}
