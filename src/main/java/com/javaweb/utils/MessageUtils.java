package com.javaweb.utils;

import com.javaweb.constant.SystemConstant;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Component
public class MessageUtils {

	public Map<String, String> getMessage(String message) {
		Map<String, String> result = new HashMap<>();
		String responseText = "";
		String alertType = "info";
		if (message.equals("update_success")) {
			responseText = "Cap nhat thanh cong";
			alertType = "success";
		} else if (message.equals("insert_success")) {
			responseText = "Them moi thanh cong";
			alertType = "success";
		} else if (message.equals("delete_success")) {
			responseText = "Xoa thanh cong";
			alertType = "success";
		} else if (message.equals("reset_password_success")) {
			responseText = "Reset mat khau thanh cong.";
			alertType = "success";
		} else if (message.equals("error_system")) {
			responseText = "Co loi he thong";
			alertType = "danger";
		} else if (message.equals("register_required_fields")) {
			responseText = "Vui long nhap day du thong tin bat buoc.";
			alertType = "danger";
		} else if (message.equals("register_confirm_password_not_match")) {
			responseText = "Mat khau xac nhan khong khop.";
			alertType = "danger";
		} else if (message.equals("register_fullname_invalid")) {
			responseText = "Ho ten khong hop le.";
			alertType = "danger";
		} else if (message.equals("register_username_existed")) {
			responseText = "Ten dang nhap da ton tai.";
			alertType = "danger";
		} else if (message.equals("username_invalid")) {
			responseText = "Ten dang nhap khong hop le.";
			alertType = "danger";
		} else if (message.equals("register_email_existed")) {
			responseText = "Email da duoc su dung.";
			alertType = "danger";
		} else if (message.equals("email_invalid")) {
			responseText = "Email khong hop le.";
			alertType = "danger";
		} else if (message.equals("phone_invalid")) {
			responseText = "So dien thoai khong hop le.";
			alertType = "danger";
		} else if (message.equals("register_gender_invalid")) {
			responseText = "Gioi tinh khong hop le.";
			alertType = "danger";
		} else if (message.equals("register_role_not_found")) {
			responseText = "Khong tim thay vai tro mac dinh cho tai khoan.";
			alertType = "danger";
		} else if (message.equals("register_fail")) {
			responseText = "Dang ky that bai. Vui long thu lai.";
			alertType = "danger";
		} else if (message.equals("change_password_weak")) {
			responseText = "Mat khau moi phai co it nhat 8 ky tu, gom chu va so.";
			alertType = "danger";
		} else if (message.equals("change_password_same_old")) {
			responseText = "Mat khau moi khong duoc trung voi mat khau cu.";
			alertType = "danger";
		} else if (message.equals("change_password_fail")) {
			responseText = "Mat khau cu khong dung hoac xac nhan mat khau khong khop.";
			alertType = "danger";
		} else if (message.equals("access_denied")) {
			responseText = "Ban khong co quyen thuc hien thao tac nay.";
			alertType = "danger";
		} else if (message.equals("full_name_invalid")) {
			responseText = "Ho ten khong hop le (khong de trong, khong chua ma HTML).";
			alertType = "danger";
		} else if (message.equals("role_invalid")) {
			responseText = "Vai tro khong hop le.";
			alertType = "danger";
		} else if (message.equals("user_payload_invalid")) {
			responseText = "Du lieu nguoi dung khong hop le.";
			alertType = "danger";
		} else if (message.equals("user_not_found")) {
			responseText = "Khong tim thay nguoi dung.";
			alertType = "danger";
		}
		result.put("message", responseText);
		result.put(SystemConstant.MESSAGE_RESPONSE, responseText);
		result.put("alert", alertType);
		return result;
	}
}
