<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<meta charset="UTF-8">
<title>Error</title>

</head>

<body>
    <div class="box">
        <p class="error">${error}</p>
        <a href="<c:url value='/'/>">🏠 홈으로 돌아가기</a>
    </div>
</body>
</html>
