describe('Halaman Admin Kategori', () => {
  const baseUrl = 'http://localhost:8000';

  beforeEach(() => {
    cy.login(); // Auto login terlebih dahulu
    cy.visit(`${baseUrl}/admin/admin/kategori`); // Halaman daftar kategori

    // Tunggu agar halaman sepenuhnya dimuat dengan memastikan elemen tersedia
    cy.contains('Daftar Kategori').should('exist'); // Pastikan halaman sudah ter-load
  });

  it('menampilkan tombol tambah kategori', () => {
    cy.contains('Daftar Kategori'); // Memastikan bahwa halaman daftar kategori terbuka
    cy.get('button').contains('Tambah Kategori').should('exist'); // Pastikan tombol 'Tambah Kategori' ada
  });

  it('menampilkan tabel kategori jika ada kategori', () => {
    // Pastikan jika ada kategori, tabel akan muncul
    cy.contains('Daftar Kategori'); // Memastikan halaman terbuka
    cy.get('table').should('exist'); // Pastikan tabel kategori ada
  });

  it('menampilkan pesan jika tidak ada kategori', () => {
    // Cek apakah pesan "Tidak ada kategori tersedia" ditampilkan ketika tidak ada kategori
    cy.contains('Daftar Kategori'); // Pastikan halaman terbuka
    cy.contains('Tidak ada kategori tersedia').should('exist'); // Pastikan pesan ini ada jika kategori kosong
  });

  it('bisa klik tombol tambah kategori dan ke halaman create', () => {
    cy.contains('Daftar Kategori'); // Memastikan bahwa halaman daftar kategori terbuka
    cy.get('button').contains('Tambah Kategori').click(); // Klik tombol 'Tambah Kategori'
    
    // Pastikan URL berubah ke halaman create kategori
    cy.url().should('include', '/admin/kategori/create');
    cy.get('input[placeholder="Nama Kategori"]').should('exist'); // Pastikan input 'Nama Kategori' ada di halaman create
  });

  it('tidak bisa submit jika nama kategori kosong', () => {
    cy.get('button').contains('Tambah Kategori').click(); // Klik tombol tambah kategori
    cy.url().should('include', '/admin/kategori/create'); // Pastikan halaman create terbuka

    // Klik tombol tambah tanpa mengisi form
    cy.get('button').contains('Tambah').click();
    
    // Pastikan error "The name field is required" muncul
    cy.contains('The name field is required').should('exist');
  });

  it('bisa menambahkan kategori baru', () => {
    const kategoriBaru = 'Minuman Segar';

    cy.get('button').contains('Tambah Kategori').click(); // Klik tombol tambah kategori
    cy.url().should('include', '/admin/kategori/create'); // Pastikan kita berada di halaman create

    // Isi form dengan nama kategori baru
    cy.get('input[placeholder="Nama Kategori"]').type(kategoriBaru);
    cy.get('button').contains('Tambah').click(); // Klik tombol submit

    // Tunggu dan pastikan kategori baru muncul di halaman index kategori
    cy.contains(kategoriBaru).should('exist');
  });
});
