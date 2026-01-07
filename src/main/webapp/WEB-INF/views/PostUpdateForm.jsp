<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정: ${post.postTitle}</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <style>
        /* ---------------------------------------------------- */
        /* 1. 기본 스타일 (ClubHome.jsp와 동일) */
        /* ---------------------------------------------------- */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f7f6;
            color: #333;
            padding-top: 40px;
            padding-bottom: 40px;
        }
        .container {
            max-width: 700px; /* 폼에 맞게 너비 조정 */
            margin: 0 auto;
            padding: 30px; 
            background-color: white; 
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08); 
            border-radius: 10px;
        }
        .main-header {
            text-align: center;
            padding-bottom: 20px;
            border-bottom: 2px solid #e0e7ff; 
            margin-bottom: 30px;
        }
        .main-title-text {
            font-size: 2em;
            font-weight: 800;
            color: #1a237e;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .main-title-text i {
            margin-right: 10px;
            color: #5c6bc0;
        }

        /* ---------------------------------------------------- */
        /* 2. 폼 요소 스타일 */
        /* ---------------------------------------------------- */
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #3f51b5;
            font-size: 1.1em;
        }
        input[type="text"], textarea {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box; /* 패딩이 너비를 포함하도록 설정 */
            font-size: 1em;
            transition: border-color 0.2s;
        }
        input[type="text"]:focus, textarea:focus {
            border-color: #5c6bc0;
            outline: none;
            box-shadow: 0 0 5px rgba(92, 107, 192, 0.5);
        }
        textarea {
            resize: vertical;
            min-height: 200px; /* 최소 높이 설정 */
        }
        
        /* ---------------------------------------------------- */
        /* 3. 버튼 스타일 */
        /* ---------------------------------------------------- */
        .button-group {
            margin-top: 30px;
            display: flex;
            gap: 15px;
            justify-content: flex-end; /* 버튼을 오른쪽으로 정렬 */
        }
        .btn-primary, .btn-secondary {
            padding: 10px 20px;
            border-radius: 6px;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: background-color 0.2s;
            border: none;
            display: inline-flex;
            align-items: center;
        }
        .btn-primary {
            background-color: #4caf50; /* 수정 완료 - 초록색 */
            color: white;
        }
        .btn-primary:hover {
            background-color: #388e3c;
        }
        .btn-secondary {
            background-color: #f44336; /* 수정 취소 - 빨간색 */
            color: white;
        }
        .btn-secondary:hover {
            background-color: #d32f2f;
        }
        .btn-primary i, .btn-secondary i {
            margin-right: 5px;
        }
    </style>
</head>

<body>
	
    <div class="container">
	
        <header class="main-header">
            <h1 class="main-title-text">
                <i class="fas fa-edit"></i> 게시글 수정
            </h1>
        </header>
        
        <form action="${pageContext.request.contextPath}/post/update" method="post">
            
            
            <input type="hidden" name="postId" value="${post.postId}">
            <input type="hidden" name="postCId" value="${post.postCId}">
            <input type="hidden" name="postMId" value="${post.postMId}">
            
            <p>
                <label for="title"><i class="fas fa-heading"></i> 제목:</label>
                <input type="text" id="title" name="postTitle" value="${post.postTitle}" required>
            </p>
            
            <p>
                <label for="content"><i class="fas fa-file-alt"></i> 내용:</label><br>
                <textarea id="content" name="postContent" required>${post.postContent}</textarea>
            </p>
            
            <div class="button-group">
                <button type="button" class="btn-secondary" onclick="location.href='${pageContext.request.contextPath}/post/detail/${post.postId}'">
                    <i class="fas fa-times-circle"></i> 수정 취소
                </button>
                <button type="submit" class="btn-primary">
                    <i class="fas fa-check-circle"></i> 수정 완료
                </button>
            </div>
        </form>
        
    </div>
</body>
</html>