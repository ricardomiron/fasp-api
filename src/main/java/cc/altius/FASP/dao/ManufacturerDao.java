/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.dao;

import cc.altius.FASP.model.DTO.PrgManufacturerDTO;
import java.util.List;

/**
 *
 * @author altius
 */
public interface ManufacturerDao {
    
    public List<PrgManufacturerDTO> getManufacturerListForSync(String lastSyncDate);
    
}
