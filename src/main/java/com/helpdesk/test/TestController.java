package com.helpdesk.test;

import com.helpdesk.user.post.mapper.PostMapper;
import com.helpdesk.admin.board.mapper.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.context.ApplicationContext;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/test")
public class TestController {

    @Autowired
    private PostMapper postMapper;

    @Autowired
    private BoardMapper boardMapper;
    
    @Autowired
    private ApplicationContext applicationContext;

    @GetMapping("/board")
    public Map<String, Object> testBoard(@RequestParam(defaultValue = "1") int boardId) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            System.out.println("=== 게시판 정보 테스트 시작 ===");
            System.out.println("요청된 boardId: " + boardId);
            
            // 게시판 정보 조회 테스트
            Map<String, Object> boardParam = new HashMap<>();
            boardParam.put("boardId", boardId);
            
            System.out.println("boardParam: " + boardParam);
            
            Map<String, Object> boardInfo = boardMapper.selectBoardInfo(boardParam);
            System.out.println("조회된 boardInfo: " + boardInfo);
            
            result.put("success", true);
            result.put("boardInfo", boardInfo);
            result.put("message", "게시판 정보 조회 성공");
            
            if (boardInfo != null) {
                result.put("allowed_ext", boardInfo.get("allowed_ext"));
                result.put("file_max_cnt", boardInfo.get("file_max_cnt"));
                result.put("board_title", boardInfo.get("board_title"));
            } else {
                result.put("message", "게시판 정보가 null입니다. 데이터베이스를 확인하세요.");
            }
            
        } catch (Exception e) {
            System.err.println("=== 게시판 정보 조회 오류 ===");
            e.printStackTrace();
            result.put("success", false);
            result.put("error", e.getMessage());
            result.put("message", "게시판 정보 조회 실패");
        }
        
        return result;
    }

    @GetMapping("/db-direct")
    public Map<String, Object> testDatabaseDirect() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            System.out.println("=== 직접 DB 테스트 시작 ===");
            
            DataSource dataSource = applicationContext.getBean(DataSource.class);
            Connection conn = dataSource.getConnection();
            
            // 테이블 존재 확인
            PreparedStatement ps1 = conn.prepareStatement(
                "SELECT COUNT(*) as cnt FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TB_BOARD_INFO'"
            );
            ResultSet rs1 = ps1.executeQuery();
            rs1.next();
            int tableExists = rs1.getInt("cnt");
            
            // 데이터 개수 확인
            PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) as cnt FROM TB_BOARD_INFO");
            ResultSet rs2 = ps2.executeQuery();
            rs2.next();
            int dataCount = rs2.getInt("cnt");
            
            // 게시판 1번 데이터 확인
            PreparedStatement ps3 = conn.prepareStatement("SELECT * FROM TB_BOARD_INFO WHERE board_id = 1");
            ResultSet rs3 = ps3.executeQuery();
            boolean hasBoard1 = rs3.next();
            
            result.put("success", true);
            result.put("tableExists", tableExists > 0);
            result.put("totalDataCount", dataCount);
            result.put("hasBoard1", hasBoard1);
            
            if (hasBoard1) {
                result.put("board1_title", rs3.getString("board_title"));
                result.put("board1_allowed_ext", rs3.getString("allowed_ext"));
            }
            
            rs1.close();
            ps1.close();
            rs2.close();
            ps2.close();
            rs3.close();
            ps3.close();
            conn.close();
            
        } catch (Exception e) {
            System.err.println("=== 직접 DB 테스트 오류 ===");
            e.printStackTrace();
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }

    @GetMapping("/check-tables")
    public Map<String, Object> checkTables() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            System.out.println("=== 테이블 상태 확인 시작 ===");
            
            DataSource dataSource = applicationContext.getBean(DataSource.class);
            Connection conn = dataSource.getConnection();
            
            // TB_BOARD_INFO 테이블 데이터 확인
            PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) as cnt FROM TB_BOARD_INFO");
            ResultSet rs1 = ps1.executeQuery();
            rs1.next();
            int boardInfoCount = rs1.getInt("cnt");
            
            // TB_BOARD_ROLE_CFG 테이블 데이터 확인
            PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) as cnt FROM TB_BOARD_ROLE_CFG");
            ResultSet rs2 = ps2.executeQuery();
            rs2.next();
            int boardRoleCount = rs2.getInt("cnt");
            
            // 전체 게시판 데이터 조회
            PreparedStatement ps3 = conn.prepareStatement("SELECT board_id, board_title, board_use_yn FROM TB_BOARD_INFO");
            ResultSet rs3 = ps3.executeQuery();
            
            java.util.List<Map<String, Object>> boardList = new java.util.ArrayList<>();
            while (rs3.next()) {
                Map<String, Object> board = new HashMap<>();
                board.put("board_id", rs3.getInt("board_id"));
                board.put("board_title", rs3.getString("board_title"));
                board.put("board_use_yn", rs3.getString("board_use_yn"));
                boardList.add(board);
            }
            
            result.put("success", true);
            result.put("boardInfoCount", boardInfoCount);
            result.put("boardRoleCount", boardRoleCount);
            result.put("boardList", boardList);
            
            rs1.close();
            ps1.close();
            rs2.close();
            ps2.close();
            rs3.close();
            ps3.close();
            conn.close();
            
        } catch (Exception e) {
            System.err.println("=== 테이블 상태 확인 오류 ===");
            e.printStackTrace();
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }

    @GetMapping("/fix-board-data")
    public Map<String, Object> fixBoardData() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            System.out.println("=== 게시판 데이터 수정 시작 ===");
            
            DataSource dataSource = applicationContext.getBean(DataSource.class);
            Connection conn = dataSource.getConnection();
            
            // 기존 데이터 삭제
            PreparedStatement deletePs1 = conn.prepareStatement("DELETE FROM TB_BOARD_ROLE_CFG WHERE board_id = 1");
            int deleteRole = deletePs1.executeUpdate();
            
            PreparedStatement deletePs2 = conn.prepareStatement("DELETE FROM TB_BOARD_INFO WHERE board_id = 1");
            int deleteBoard = deletePs2.executeUpdate();
            
            // IDENTITY 컬럼 리셋
            PreparedStatement resetPs = conn.prepareStatement("DBCC CHECKIDENT ('TB_BOARD_INFO', RESEED, 0)");
            resetPs.execute();
            
            // 새로운 게시판 데이터 삽입
            String insertSql = "INSERT INTO TB_BOARD_INFO (" +
                "sys_id, board_type, board_title, board_desc, " +
                "reply_type, page_post_cnt, secret_use_yn, file_max_cnt, " +
                "editor_use_yn, status_use_yn, reply_yn, board_use_yn, " +
                "allowed_ext, reg_id, reg_nm, reg_ip, reg_dt" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
            
            PreparedStatement ps = conn.prepareStatement(insertSql);
            ps.setString(1, "helpdesk");
            ps.setString(2, "QNA");
            ps.setString(3, "IT 문의게시판");
            ps.setString(4, "IT 관련 문의사항을 등록하는 게시판입니다.");
            ps.setString(5, "N");
            ps.setInt(6, 10);
            ps.setString(7, "Y");
            ps.setInt(8, 5);
            ps.setString(9, "Y");
            ps.setString(10, "Y");
            ps.setString(11, "Y");
            ps.setString(12, "Y");
            ps.setString(13, "jpg,jpeg,png,gif,pdf,doc,docx,xls,xlsx,zip");
            ps.setString(14, "admin");
            ps.setString(15, "시스템관리자");
            ps.setString(16, "127.0.0.1");
            
            int insertResult = ps.executeUpdate();
            
            // 권한 설정 삽입
            String insertRoleSql = "INSERT INTO TB_BOARD_ROLE_CFG (" +
                "board_id, manage_role, update_role, delete_role, " +
                "read_role, write_role, secret_role, reply_role, print_role, " +
                "write_btn_show_yn, reply_btn_show_yn" +
                ") VALUES (1, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            PreparedStatement ps2 = conn.prepareStatement(insertRoleSql);
            ps2.setString(1, "1,2");
            ps2.setString(2, "1,2");
            ps2.setString(3, "1,2");
            ps2.setString(4, "1,2,3");
            ps2.setString(5, "1,2,3");
            ps2.setString(6, "1,2,3");
            ps2.setString(7, "1,2");
            ps2.setString(8, "1,2,3");
            ps2.setString(9, "Y");
            ps2.setString(10, "Y");
            
            int insertRoleResult = ps2.executeUpdate();
            
            result.put("success", true);
            result.put("deletedRole", deleteRole);
            result.put("deletedBoard", deleteBoard);
            result.put("boardInserted", insertResult > 0);
            result.put("roleInserted", insertRoleResult > 0);
            result.put("message", "게시판 데이터 수정 완료");
            
            deletePs1.close();
            deletePs2.close();
            resetPs.close();
            ps.close();
            ps2.close();
            conn.close();
            
        } catch (Exception e) {
            System.err.println("=== 게시판 데이터 수정 오류 ===");
            e.printStackTrace();
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }

    @GetMapping("/check-posts")
    public Map<String, Object> checkPosts() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            System.out.println("=== 게시물 데이터 확인 시작 ===");
            
            DataSource dataSource = applicationContext.getBean(DataSource.class);
            Connection conn = dataSource.getConnection();
            
            // 전체 게시물 개수
            PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) as cnt FROM TB_POST_INFO");
            ResultSet rs1 = ps1.executeQuery();
            rs1.next();
            int totalPosts = rs1.getInt("cnt");
            
            // 게시판 1번의 게시물 개수
            PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) as cnt FROM TB_POST_INFO WHERE board_id = 1");
            ResultSet rs2 = ps2.executeQuery();
            rs2.next();
            int board1Posts = rs2.getInt("cnt");
            
            // 최근 게시물 5개 조회
            PreparedStatement ps3 = conn.prepareStatement(
                "SELECT TOP 5 post_seq, board_id, post_title, reg_id, reg_nm, reg_dt, post_use_yn " +
                "FROM TB_POST_INFO ORDER BY post_seq DESC"
            );
            ResultSet rs3 = ps3.executeQuery();
            
            java.util.List<Map<String, Object>> recentPosts = new java.util.ArrayList<>();
            while (rs3.next()) {
                Map<String, Object> post = new HashMap<>();
                post.put("post_seq", rs3.getInt("post_seq"));
                post.put("board_id", rs3.getInt("board_id"));
                post.put("post_title", rs3.getString("post_title"));
                post.put("reg_id", rs3.getString("reg_id"));
                post.put("reg_nm", rs3.getString("reg_nm"));
                post.put("reg_dt", rs3.getTimestamp("reg_dt"));
                post.put("post_use_yn", rs3.getString("post_use_yn"));
                recentPosts.add(post);
            }
            
            result.put("success", true);
            result.put("totalPosts", totalPosts);
            result.put("board1Posts", board1Posts);
            result.put("recentPosts", recentPosts);
            
            rs1.close();
            ps1.close();
            rs2.close();
            ps2.close();
            rs3.close();
            ps3.close();
            conn.close();
            
        } catch (Exception e) {
            System.err.println("=== 게시물 데이터 확인 오류 ===");
            e.printStackTrace();
            result.put("success", false);
            result.put("error", e.getMessage());
        }
        
        return result;
    }
}