document.addEventListener('DOMContentLoaded', function() {
    togglePasswordVisibility();

    const password_reset_form = document.getElementById('password-reset');
    const login_form = document.getElementById('login');
    const send_link_form = document.getElementById('send-link');
    const errorMessageContainer = document.getElementById('errorMessageContainer');
    
    function outputMessage(dataList){
        dataList.forEach(item => {
            console.log(item);
            const p = document.createElement('p');
            p.innerHTML = `${item}`;
            errorMessageContainer.appendChild(p);
        })
    }

    if(password_reset_form){
        password_reset_form.addEventListener('submit', function(event) {
            event.preventDefault();
            
            errorMessageContainer.innerHTML = '';

            const new_password1 = document.getElementById('id_new_password1').value;
            const new_password2 = document.getElementById('id_new_password2').value;
            let error = [];
            
            if(new_password1.length < 8){
                error.push('Password must be at least 8 characters.');
                
            }
            if(new_password1 != new_password2){
                error.push('Password do not match.');
            }
            if(/^\d+$/.test(new_password1)){
                error.push('Password cannot be only numbers.');
            }
            console.log(error);
            if(error.length > 0){
                outputMessage(error);
                return;
            }else this.submit();
            
        });
    };
});

function togglePasswordVisibility() {
    const passwordInput = document.querySelectorAll('input[type="password"]');
    
    if (passwordInput) {
        passwordInput.forEach(input => {
            const wrapper = document.createElement('div');
            wrapper.classList.add('password-wrapper');
            
            const eyeIcon = document.createElement('span');
            eyeIcon.classList.add('toggle-password');
            eyeIcon.innerHTML = `
                <svg viewBox="0 0 190 67" xmlns="http://www.w3.org/2000/svg">
                    <path fill-rule="evenodd" clip-rule="evenodd" d="M0.774536 3.09583C8.69878 11.8704 21.5691 22.8716 41.7745 33.3818C38.7745 36.9532 25.1745 51.5958 20.7745 53.5958C25.2745 52.4365 42.0745 41.7156 47.2745 36.1068C55.7939 40.1175 64.9769 43.466 74.5808 45.5958C73.7745 51.5958 70.7745 61.5958 65.7745 66.0958C69.7745 64.9257 78.7745 59.4866 82.7745 47.0907C86.7876 47.663 90.8595 48.0058 94.9737 48.0811C98.9779 48.1543 102.915 47.9719 106.775 47.5675C107.608 51.2436 111.575 60.0958 120.775 66.0958C118.941 63.6941 115.075 56.4112 114.275 46.4933C125.349 44.4828 135.687 40.7322 145.023 36.1068C150.021 47.3156 162.273 52.4365 166.775 53.5958C159.975 48.7958 152.247 38.1198 150.233 33.3818C167.86 23.6723 181.392 11.2028 188.775 2.59584L184.775 0.64311C171.623 15.9428 136.459 42.9002 94.9737 42.1431C53.4887 41.386 18.0517 15.3119 4.77454 0.64311L0.774536 3.09583Z" fill="black" stroke="black"/>
                </svg>
            `;
            
            input.parentNode.insertBefore(wrapper, input);
            wrapper.appendChild(input);
            wrapper.appendChild(eyeIcon);
            
            eyeIcon.addEventListener('click', function() {
                const type = input.getAttribute('type') === 'password' ? 'text' : 'password';
                input.setAttribute('type', type);
                
                this.innerHTML = type === 'password' ? 
                `
                    <svg viewBox="0 0 190 67" xmlns="http://www.w3.org/2000/svg">
                        <path fill-rule="evenodd" clip-rule="evenodd" d="M0.774536 3.09583C8.69878 11.8704 21.5691 22.8716 41.7745 33.3818C38.7745 36.9532 25.1745 51.5958 20.7745 53.5958C25.2745 52.4365 42.0745 41.7156 47.2745 36.1068C55.7939 40.1175 64.9769 43.466 74.5808 45.5958C73.7745 51.5958 70.7745 61.5958 65.7745 66.0958C69.7745 64.9257 78.7745 59.4866 82.7745 47.0907C86.7876 47.663 90.8595 48.0058 94.9737 48.0811C98.9779 48.1543 102.915 47.9719 106.775 47.5675C107.608 51.2436 111.575 60.0958 120.775 66.0958C118.941 63.6941 115.075 56.4112 114.275 46.4933C125.349 44.4828 135.687 40.7322 145.023 36.1068C150.021 47.3156 162.273 52.4365 166.775 53.5958C159.975 48.7958 152.247 38.1198 150.233 33.3818C167.86 23.6723 181.392 11.2028 188.775 2.59584L184.775 0.64311C171.623 15.9428 136.459 42.9002 94.9737 42.1431C53.4887 41.386 18.0517 15.3119 4.77454 0.64311L0.774536 3.09583Z" fill="black" stroke="black"/>
                    </svg>
                ` 
                : 
                `
                    <svg viewBox="0 0 196 86" xmlns="http://www.w3.org/2000/svg">
                        <path fill-rule="evenodd" clip-rule="evenodd" d="M0.705811 41.4976C14.7811 28.761 53.9266 -0.28805 97.9052 0.516371C141.884 1.32079 180.763 29.4313 194.706 41.4976C180.763 57.7536 141.884 86.2878 97.9052 85.4834C53.9266 84.6789 14.7811 57.0833 0.705811 41.4976ZM98.4052 80.4976C139.89 81.2547 172.554 57.1217 185.706 41.8219C175.886 33.3426 158.464 17.8265 130.206 10.4976C130.206 10.4976 142.104 12.6463 141.405 35.3221C140.706 57.9979 117.459 71.998 98.4052 71.998C79.3514 71.998 55.2061 59.3214 54.9052 35.3221C54.6044 11.3228 65.7058 10.4976 65.7058 10.4976C35.9422 17.0599 19.9834 32.5427 9.70581 41.8219C22.983 56.4908 56.9202 79.7405 98.4052 80.4976ZM98.4052 59.3214C113.041 59.3214 124.905 47.6808 124.905 33.3213C124.905 18.9618 113.041 7.32114 98.4052 7.32114C83.7697 7.32114 71.9052 18.9618 71.9052 33.3213C71.9052 47.6808 83.7697 59.3214 98.4052 59.3214Z" fill="black" stroke="black"/>
                    </svg>
                `;
            });
        });
    }
}

const submitBtn = document.querySelector('button[type="submit"]');
console.log(submitBtn);
submitBtn.addEventListener('click', () => {
    const form = document.getElementById('login') || document.getElementById('send-link') || document.getElementById('password-reset');
    const authLoad = document.querySelector('.authLoad');
    if (form.checkValidity()) {
        authLoad.classList.add('active');
    } else {
        loginForm.reportValidity();
    }
})