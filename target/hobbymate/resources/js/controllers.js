function addToCart(action) {
    document.addForm.action = action;
    document.addForm.submit();
    alert("도서가 장바구니에 추가되었습니다!");
}

function removeFromCart(action) {
    console.log("removeFromCart() 실행됨");
    console.log("action 경로:", action);

    const form = document.getElementById("removeForm");
    if (!form) {
        console.error("removeForm을 찾을 수 없습니다.");
        return;
    }

    form.action = action;
    console.log("form.action 설정 완료:", form.action);

    form.submit();
}

function clearCart() {
    console.log("clearCart() 실행됨");

    const form = document.getElementById("clearForm");
    if (!form) {
        console.error("clearForm을 찾을 수 없습니다.");
        return;
    }

    form.submit();
    window.location.reload();
}

console.log("controllers.js 로드됨!");