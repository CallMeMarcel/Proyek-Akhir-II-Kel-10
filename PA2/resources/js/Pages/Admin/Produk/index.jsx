// resources/js/Pages/Admin/Produk/Dashboard.jsx
import { Link, useForm } from "@inertiajs/react";
import AdminLayout from "@/Layouts/AdminLayout";

export default function Dashboard({ categories, products }) {
    return (
        <AdminLayout>
            <AdminProduk products={products} categories={categories} />
        </AdminLayout>
    );
}

function AdminProduk({ products = [] }) {
    const { delete: destroy } = useForm();

    const handleDelete = (productId) => {
        if (confirm("Apakah Anda yakin ingin menghapus produk ini?")) {
            destroy(route("admin.produk.destroy", productId), {
                preserveScroll: true,
                onSuccess: () => alert("Produk berhasil dihapus"),
                onError: (errors) => console.log(errors),
            });
        }
    };

    return (
        <div className="p-6 bg-white shadow-md rounded-md">
            <h2 className="text-2xl font-bold mb-4">Kelola Produk</h2>

            <Link
                href={route("admin.produk.create")}
                className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
            >
                Tambah Produk
            </Link>

            <table className="w-full border mt-4">
                <thead>
                    <tr className="bg-gray-200">
                        <th className="p-2">Gambar</th>
                        <th className="p-2">Nama</th>
                        <th className="p-2">Deskripsi</th>
                        <th className="p-2">Harga</th>
                        <th className="p-2">Status</th>
                        <th className="p-2">Kategori</th>
                        <th className="p-2">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    {products.map((product) => (
                        <tr key={product.id} className="border-t">
                            <td className="p-2">
                                <img
                                    src={product.image ? `/storage/${product.image}` : "/images/default.png"}
                                    alt={product.title}
                                    className="w-12 h-12 object-cover rounded"
                                />
                            </td>
                            <td className="p-2">{product.title}</td>
                            <td className="p-2">{product.description}</td>
                            <td className="p-2">Rp {product.price.toLocaleString()}</td>
                            <td className="p-2">
                                {product.status === "available" ? "Tersedia" : "Tidak Tersedia"}
                            </td>
                            <td className="p-2">{product.category?.name || "Tidak ada kategori"}</td>
                            <td className="p-2">
                                <Link
                                    href={route("admin.produk.edit", product.id)}
                                    className="bg-yellow-500 text-white px-2 py-1 rounded mr-2 hover:bg-yellow-600"
                                >
                                    Edit
                                </Link>

                                <button
                                    onClick={() => handleDelete(product.id)}
                                    className="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600"
                                >
                                    Hapus
                                </button>
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
}
