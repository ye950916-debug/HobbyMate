<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세: ${post.postTitle}</title>

<link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.min.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/theme.css'/>">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>

<body class="bg-light pt-5 pb-5">
    
    <div class="container" style="max-width: 900px;"> 
        
        <div class="card shadow p-4 p-md-5 border rounded-3 bg-white">
            
            <h2 class="fw-bold mb-4 pb-3 border-bottom text-dark">
                ${post.postTitle}
            </h2>
            
            <div class="d-flex justify-content-between align-items-center mb-4 text-muted small">
                <div>
                    <i class="fas fa-user-edit me-1"></i> <strong>작성자:</strong> ${post.postMId}
                </div>
                <div>
                    <i class="fas fa-calendar-alt me-1"></i> <strong>작성일:</strong> 
                    <fmt:parseDate value="${post.postCreatedDate}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" />
                    <fmt:formatDate value="${parsedDate}" pattern="yyyy.MM.dd HH:mm" />
                </div>
                <div>
                    <i class="fas fa-eye me-1"></i> <strong>조회수:</strong> ${post.postViewCount}
                </div>
            </div>
            
            <hr class="my-4">
            
            <div class="p-3 border rounded bg-light" style="min-height: 200px; white-space: pre-wrap;">
                ${post.postContent}
            </div>
            
            <hr class="my-4">
            
            <div class="d-flex justify-content-between align-items-center">
                
                <div class="d-flex gap-2">
                    <c:if test="${isAuthor}">
                        <form action="${pageContext.request.contextPath}/post/update/${post.postId}" method="get" style="display:inline;">
                            <button type="submit" class="btn btn-sm btn-outline-secondary fw-semibold">
                                <i class="fas fa-edit me-1"></i> 수정
                            </button>
                        </form>
                        
                        <form action="${pageContext.request.contextPath}/post/delete" method="post" 
                              style="display:inline;" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                            <input type="hidden" name="postId" value="${post.postId}">
                            <button type="submit" class="btn btn-sm btn-danger fw-semibold">
                                <i class="fas fa-trash-alt me-1"></i> 삭제
                            </button>
                        </form>
                    </c:if>
                </div>

                <a href="${pageContext.request.contextPath}/club/home?clubId=${post.postCId}" class="text-decoration-none">
                    <button type="button" class="btn btn-primary rounded-pill px-4 fw-semibold">
                        <i class="fas fa-list me-1"></i> 목록으로 돌아가기
                    </button>
                </a>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>