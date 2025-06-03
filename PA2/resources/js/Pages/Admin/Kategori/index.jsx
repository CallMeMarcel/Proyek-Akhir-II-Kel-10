import { Link, useForm } from "@inertiajs/react";
import AdminLayout from "@/Layouts/AdminLayout";

export default function IndexCategori({ categories = [] }) {
    const { delete: destroy } = useForm();

    return (
        <AdminLayout>
            <div className="p-6 bg-white shadow-md rounded-md">
                <h2 className="text-2xl font-bold mb-4">Daftar Kategori</h2>
                
                {/* Tombol Tambah Kategori */}
                <Link 
                    href={route("admin.kategori.create")} 
                    className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 inline-block mb-4"
                >
                    Tambah Kategori
                </Link>

                {/* Tabel Kategori */}
                {categories.length === 0 ? (
                    <p className="text-gray-500">Tidak ada kategori tersedia.</p>
                ) : (
                    <table className="w-full border mt-4">
                        <thead>
                            <tr className="bg-gray-200">
                                <th className="p-2">ID</th>
                                <th className="p-2">Nama Kategori</th>
                                <th className="p-2">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            {categories.map((cat) => (
                                <tr key={cat.id} className="border-t">
                                    <td className="p-2">{cat.id}</td>
                                    <td className="p-2">{cat.name}</td>
                                    <td className="p-2">
                                        <button 
                                            onClick={() => destroy(`/admin/kategori/${cat.id}`, { method: "delete" })} 
                                            className="bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600"
                                        >
                                            Hapus
                                        </button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                )}
            </div>
        </AdminLayout>
    );
}
