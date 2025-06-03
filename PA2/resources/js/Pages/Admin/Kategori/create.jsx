import { useState } from "react";
import { useForm, Link } from "@inertiajs/react";
import AdminLayout from "@/Layouts/AdminLayout";

export default function AdminCategori({ categories = [] }) {
    const { data, setData, post, put } = useForm({ name: "" });
    const [editing, setEditing] = useState(null);

    const handleSubmit = (e) => {
        e.preventDefault();
        if (editing) {
            put(`/admin/kategori/${editing}`);
        } else {
            post("/admin/kategori");
        }
        setEditing(null);
        setData("name", "");
    };

    return (
        <AdminLayout>
            <div className="p-6 bg-white shadow-md rounded-md">
                <h2 className="text-2xl font-bold mb-4">Kelola Kategori</h2>
                <form onSubmit={handleSubmit} className="mb-4 flex items-center">
                    <input 
                        type="text" 
                        value={data.name} 
                        onChange={(e) => setData("name", e.target.value)} 
                        className="border p-2 mr-2 flex-1" 
                        placeholder="Nama Kategori" 
                    />
                    <div className="flex space-x-2">
                        <button type="submit" className="bg-blue-500 text-white p-2 rounded hover:bg-blue-600">
                            {editing ? "Update" : "Tambah"}
                        </button>
                        <Link 
                            href={route("admin.kategori.index")} 
                            className="bg-gray-500 text-white p-2 rounded hover:bg-gray-600"
                        >
                            Batal
                        </Link>
                    </div>
                </form>
            </div>
        </AdminLayout>
    );
}