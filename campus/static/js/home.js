function copyCode() {
    const codeText = document.getElementById("code-block").innerText;
    
    navigator.clipboard.writeText(codeText).then(() => {
        const btn = document.querySelector(".copy-btn");
        btn.innerHTML = `
            <span class="copyIcon">
                Copied!
            </span>
        `;
        
        setTimeout(() => {
            btn.innerHTML = `
                <span class="copyIcon">
                    <svg  viewBox="0 0 365 405" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M69.5 60.5V40.5C69.5 20.6178 85.6178 4.5 105.5 4.5H324.5C344.382 4.5 360.5 20.6178 360.5 40.5V301.5C360.5 321.382 344.382 337.5 324.5 337.5H305.5M40.5 400.5H259.5C279.382 400.5 295.5 384.382 295.5 364.5V103.5C295.5 83.6178 279.382 67.5 259.5 67.5H40.5C20.6177 67.5 4.5 83.6177 4.5 103.5V364.5C4.5 384.382 20.6178 400.5 40.5 400.5Z" />
                    </svg>
                </span>
            `;
        }, 2000);
    }).catch(err => {
        console.error('Failed to copy: ', err);
    });
}