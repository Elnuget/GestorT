// custom.js
function confirmLogout() {
    var confirmLogout = confirm("¿Estás seguro de que deseas cerrar sesión?");

    if (confirmLogout) {
        // Si el usuario confirma, redirige a la ruta de cerrar sesión
        window.location.href = "/logout";  
    } else {
        // Si el usuario cancela, no hace nada
    }
}
