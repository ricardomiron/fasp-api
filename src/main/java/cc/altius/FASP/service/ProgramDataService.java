/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.service;

import cc.altius.FASP.exception.CouldNotSaveException;
import cc.altius.FASP.model.CustomUserDetails;
import cc.altius.FASP.model.ProgramData;
import cc.altius.FASP.model.SimpleObject;
import cc.altius.FASP.model.Version;
import java.util.List;

/**
 *
 * @author altius
 */
public interface ProgramDataService {

    public ProgramData getProgramData(int programId, int versionId, CustomUserDetails curUser);

    public Version saveProgramData(ProgramData programData, CustomUserDetails curUser) throws CouldNotSaveException;

    public List<SimpleObject> getVersionTypeList();

    public List<SimpleObject> getVersionStatusList();
}
