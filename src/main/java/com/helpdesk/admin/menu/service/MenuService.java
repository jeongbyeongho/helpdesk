package com.helpdesk.admin.menu.service;

import com.helpdesk.admin.menu.mapper.MenuMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class MenuService {

    @Autowired
    private MenuMapper menuMapper;

    public List<Map<String, Object>> getMenuList(String sysId) {
        Map<String, Object> param = new HashMap<>();
        param.put("sysId", sysId);
        return menuMapper.selectMenuList(param);
    }

    public Map<String, Object> getMenuInfo(int menuId) {
        Map<String, Object> param = new HashMap<>();
        param.put("menuId", menuId);
        return menuMapper.selectMenuInfo(param);
    }

    public List<Map<String, Object>> getUpperMenuList(String sysId) {
        Map<String, Object> param = new HashMap<>();
        param.put("sysId", sysId);
        return menuMapper.selectUpperMenuList(param);
    }

    public List<Map<String, Object>> getConnectMenuList(String sysId) {
        Map<String, Object> param = new HashMap<>();
        param.put("sysId", sysId);
        return menuMapper.selectConnectMenuList(param);
    }

    public List<Map<String, Object>> getBoardListForMenu(String sysId) {
        Map<String, Object> param = new HashMap<>();
        param.put("sysId", sysId);
        return menuMapper.selectBoardListForMenu(param);
    }

    public int getNextSortOrder(String sysId) {
        Map<String, Object> param = new HashMap<>();
        param.put("sysId", sysId);
        return menuMapper.selectNextSortOrder(param);
    }

    @Transactional
    public void insertMenu(Map<String, Object> param) {
        menuMapper.insertMenuInfo(param);
    }

    @Transactional
    public void updateMenu(Map<String, Object> param) {
        menuMapper.updateMenuInfo(param);
    }

    @Transactional
    public void updateMenuSortOrder(List<Map<String, Object>> sortList) {
        for (Map<String, Object> item : sortList) {
            menuMapper.updateMenuSortOrder(item);
        }
    }

    @Transactional
    public void deleteMenu(int menuId) {
        // 하위 메뉴 먼저 삭제
        Map<String, Object> param = new HashMap<>();
        param.put("upperMenuId", menuId);
        List<String> childIds = menuMapper.selectChildMenuIdList(param);
        for (String childId : childIds) {
            Map<String, Object> childParam = new HashMap<>();
            childParam.put("upperMenuId", Integer.parseInt(childId));
            menuMapper.deleteMenuByUpperId(childParam);
        }
        menuMapper.deleteMenuByUpperId(param);

        Map<String, Object> delParam = new HashMap<>();
        delParam.put("menuId", menuId);
        menuMapper.deleteMenuInfo(delParam);
    }

    // 메뉴 권한
    public List<Map<String, Object>> getMenuRoleList(int menuId) {
        Map<String, Object> param = new HashMap<>();
        param.put("menuId", menuId);
        return menuMapper.selectMenuRoleList(param);
    }

    @Transactional
    public void saveMenuRoles(int menuId, String menuType, Integer contentId, List<Integer> roleNos) {
        Map<String, Object> delParam = new HashMap<>();
        delParam.put("menuId", menuId);
        delParam.put("roleType", "A");
        menuMapper.deleteMenuRole(delParam);

        if (roleNos != null) {
            for (Integer roleNo : roleNos) {
                Map<String, Object> param = new HashMap<>();
                param.put("menuId", menuId);
                param.put("roleNo", roleNo);
                param.put("roleType", "A");
                param.put("menuType", menuType);
                param.put("contentId", contentId);
                menuMapper.insertMenuRole(param);
            }
        }
    }
}
