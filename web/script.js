const app = document.getElementById('app');
let isAtm = false;

window.addEventListener('message', function(event) {
    const item = event.data;

    if (item.action === 'open') {
        app.classList.remove('hidden');
        isAtm = item.data.isAtm;
        
        document.getElementById('player-name').textContent = item.data.name;
        // Show job if available
        if (item.data.job) {
            document.getElementById('player-job').textContent = item.data.job;
        } else {
            document.getElementById('player-job').textContent = 'Unemployed';
        }
        
        updateBalances(item.data.cash, item.data.bank);
        
        // Reset to home tab
        switchTab('home');
    } else if (item.action === 'update') {
        updateBalances(item.data.cash, item.data.bank);
    } else if (item.action === 'close') {
        closeUI();
    }
});

function updateBalances(cash, bank) {
    document.getElementById('cash-balance').textContent = '$' + cash.toLocaleString('en-US');
    document.getElementById('bank-balance').textContent = '$' + bank.toLocaleString('en-US');
}

function switchTab(tabName) {
    // Hide all tabs
    document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
    document.querySelectorAll('.nav-btn').forEach(el => el.classList.remove('active'));
    
    // Show selected tab
    document.getElementById(tabName + '-tab').classList.add('active');
    
    // Highlight nav button
    const buttons = document.querySelectorAll('.nav-btn');
    buttons.forEach(btn => {
        if (btn.getAttribute('onclick').includes(tabName)) {
            btn.classList.add('active');
        }
    });
}

function closeUI() {
    app.classList.add('hidden');
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    });
}

function deposit() {
    const amount = document.getElementById('deposit-amount').value;
    if (!amount || amount <= 0) return;

    fetch(`https://${GetParentResourceName()}/deposit`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            amount: parseInt(amount)
        })
    });
    document.getElementById('deposit-amount').value = '';
}

function withdraw() {
    const amount = document.getElementById('withdraw-amount').value;
    if (!amount || amount <= 0) return;

    fetch(`https://${GetParentResourceName()}/withdraw`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            amount: parseInt(amount)
        })
    });
    document.getElementById('withdraw-amount').value = '';
}

function transfer() {
    const target = document.getElementById('transfer-target').value;
    const amount = document.getElementById('transfer-amount').value;
    
    if (!target || !amount || amount <= 0) return;

    fetch(`https://${GetParentResourceName()}/transfer`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            target: parseInt(target),
            amount: parseInt(amount)
        })
    });
    
    document.getElementById('transfer-target').value = '';
    document.getElementById('transfer-amount').value = '';
}

document.onkeyup = function(data) {
    if (data.which == 27) {
        closeUI();
    }
};
