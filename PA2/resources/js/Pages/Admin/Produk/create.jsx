import { useForm, Link } from "@inertiajs/react";
import AdminLayout from "@/Layouts/AdminLayout";

export default function CreateProduct({ categories = [] }) {
    const { data, setData, post, processing, reset } = useForm({
        title: "",
        description: "",
        price: "",
        status: "available",
        category_id: categories.length > 0 ? categories[0]?.id : "",
        image: null,
    });

    const handleSubmit = (e) => {
        e.preventDefault();
        const formData = new FormData();
        formData.append("title", data.title);
        formData.append("description", data.description);
        formData.append("price", data.price);
        formData.append("status", data.status);
        formData.append("category_id", data.category_id);
        if (data.image) {
            formData.append("image", data.image);
        }

        post(route("admin.produk.store"), {
            data: formData,
            onSuccess: () => reset(),
        });
    };

    return (
        <AdminLayout>
            <div className="p-6 bg-white shadow-md rounded-md">
                <h2 className="text-2xl font-bold mb-4">Tambah Produk</h2>
                <form onSubmit={handleSubmit} className="p-4 border rounded-md">
                    <div className="grid grid-cols-2 gap-4">
                        <input 
                            type="text" 
                            placeholder="Nama Produk" 
                            className="border p-2 rounded w-full" 
                            value={data.title}
                            onChange={(e) => setData("title", e.target.value)}
                            required
                        />
                        <input 
                            type="number" 
                            placeholder="Harga" 
                            className="border p-2 rounded w-full" 
                            value={data.price}
                            onChange={(e) => setData("price", e.target.value)}
                            required
                        />
                    </div>
                    <div className="mt-2">
                        <textarea 
                            placeholder="Deskripsi" 
                            className="border p-2 rounded w-full"
                            value={data.description}
                            onChange={(e) => setData("description", e.target.value)}
                            required
                        />
                    </div>
                    <div className="mt-2">
                        <select 
                            className="border p-2 rounded w-full" 
                            value={data.category_id} 
                            onChange={(e) => setData("category_id", e.target.value)}
                        >
                            {categories.length > 0 ? (
                                categories.map((category) => (
                                    <option key={category.id} value={category.id}>{category.name}</option>
                                ))
                            ) : (
                                <option value="">Tidak ada kategori</option>
                            )}
                        </select>
                    </div>
                    <div className="mt-2">
                        <select 
                            className="border p-2 rounded w-full" 
                            value={data.status} 
                            onChange={(e) => setData("status", e.target.value)}
                        >
                            <option value="available">Tersedia</option>
                            <option value="unavailable">Tidak Tersedia</option>
                        </select>
                    </div>
                    <div className="mt-2">
                        <input 
                            type="file" 
                            className="border p-2 rounded w-full" 
                            onChange={(e) => setData("image", e.target.files[0])}
                            required
                        />
                    </div>
                    <div className="mt-4 flex space-x-2">
                        <button 
                            type="submit" 
                            className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
                            disabled={processing}
                        >
                            {processing ? "Menyimpan..." : "Tambah Produk"}
                        </button>
                        <Link 
                            href={route("admin.produk.index")} 
                            className="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600"
                        >
                            Batal
                        </Link>
                    </div>
                </form>
            </div>
        </AdminLayout>
    );
}