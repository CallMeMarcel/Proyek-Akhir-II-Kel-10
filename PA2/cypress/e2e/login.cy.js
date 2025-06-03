describe('Halaman Login - del_cafe', () => {
    const baseUrl = 'http://localhost:8000';
  
    it('menampilkan halaman login dengan form lengkap', () => {
      cy.visit(`${baseUrl}/login`);
      cy.contains('Welcome Admin ☕');
      cy.get('input[name="email"]').should('exist');
      cy.get('input[name="password"]').should('exist');
      cy.get('button').contains('Log in').should('exist');
    });
  
    it('menampilkan error saat form kosong dikirim', () => {
      cy.visit(`${baseUrl}/login`);
      cy.get('button').contains('Log in').click();
  
      cy.contains('The email field is required').should('exist');
      cy.contains('The password field is required').should('exist');
    });
  
    it('menampilkan error saat email/password salah', () => {
      cy.visit(`${baseUrl}/login`);
      cy.get('input[name="email"]').type('salah@email.com');
      cy.get('input[name="password"]').type('passwordsalah');
      cy.get('button').contains('Log in').click();
  
      cy.contains('These credentials do not match our records.').should('exist');
    });
  
    // OPTIONAL: Uji login berhasil kalau punya akun dummy
    it('login berhasil dengan data valid', () => {
      cy.visit(`${baseUrl}/login`);
      cy.get('input[name="email"]').type('admin@example.com');
      cy.get('input[name="password"]').type('password123');
      cy.get('button').contains('Log in').click();
  
      // Cek redirect misalnya ke /dashboard
      cy.url().should('not.include', '/login');
      cy.contains('Dashboard').should('exist');
    });
  });
  