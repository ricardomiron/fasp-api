/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cc.altius.FASP.utils;

/**
 *
 * @author akil
 */
public class ArrayUtils {

    public static String convertArrayToString(String[] ids) {
        if (ids == null || ids.length == 0) {
            return "";
        } else {
            return String.join(",", ids);
        }
    }
}