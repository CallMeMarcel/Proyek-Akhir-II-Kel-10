import { Head, useForm, usePage } from "@inertiajs/react";
import AdminLayout from "@/Layouts/AdminLayout";
import { router } from '@inertiajs/react';

export default function EditProduct({ product, categories }) {
    const { errors } = usePage().props;

    const { data, setData, reset, progress } = useForm({
        title: product.title || "",
        description: product.description || "",
        price: product.price || "",
        status: product.status || "available",
        category_id: product.category_id || "",
        image: null,
    });

    const handleSubmit = (e) => {
        e.preventDefault();

        if (!product.id) {
            console.error("Product ID tidak ditemukan!");
            return;
        }

        const formData = new FormData();
        formData.append("title", data.title);
        formData.append("description", data.description);
        formData.append("price", data.price.toString().replace(",", ".")); // Ganti koma jadi titik
        formData.append("status", data.status);
        formData.append("category_id", data.category_id);
        if (data.image) {
            formData.append("image", data.image);
        }
        formData.append("_method", "put"); // Agar dikenali sebagai PUT oleh Laravel

        router.post(route('admin.produk.update', product.id), formData, {
            preserveScroll: true,
            onSuccess: () => {
                alert("Produk berhasil diperbarui!");
                router.visit(route('admin.produk.index'));
            },
            onError: (errors) => {
                console.log("Terjadi error validasi:", errors);
            }
        });
    };

    return (
        <AdminLayout>
            <div className="p-6 bg-white shadow-md rounded-md">
                <h2 className="text-2xl font-bold mb-4">Edit Produk</h2>

                {/* Form Edit Produk */}
                <form onSubmit={handleSubmit} className="mb-6 p-4 border rounded-md">
                    <h3 className="text-lg font-semibold mb-2">Edit Produk</h3>
                    <div className="grid grid-cols-2 gap-4">
                        <div>
                            <input 
                                type="text" 
                                placeholder="Nama Produk" 
                                className="border p-2 rounded w-full" 
                                value={data.title}
                                onChange={(e) => setData("title", e.target.value)}
                                required
                            />
                            {errors.title && <p className="text-red-500 text-sm">{errors.title}</p>}
                        </div>
                        <div>
                            <input 
                                type="number" 
                                placeholder="Harga" 
                                className="border p-2 rounded w-full" 
                                value={data.price}
                                onChange={(e) => setData("price", e.target.value)}
                                required
                            />
                            {errors.price && <p className="text-red-500 text-sm">{errors.price}</p>}
                        </div>
                    </div>

                    <div className="mt-2">
                        <textarea 
                            placeholder="Deskripsi" 
                            className="border p-2 rounded w-full"
                            value={data.description}
                            onChange={(e) => setData("description", e.target.value)}
                            required
                        />
                        {errors.description && <p className="text-red-500 text-sm">{errors.description}</p>}
                    </div>

                    <div className="mt-2">
                        <select 
                            className="border p-2 rounded w-full" 
                            value={data.category_id} 
                            onChange={(e) => setData("category_id", e.target.value)}
                            required
                        >
                            <option value="" disabled>Pilih Kategori</option>
                            {categories.length > 0 ? (
                                categories.map((category) => (
                                    <option key={category.id} value={category.id}>
                                        {category.name}
                                    </option>
                                ))
                            ) : (
                                <option value="">Tidak ada kategori</option>
                            )}
                        </select>
                        {errors.category_id && <p className="text-red-500 text-sm">{errors.category_id}</p>}
                    </div>

                    <div className="mt-2">
                        <select 
                            className="border p-2 rounded w-full" 
                            value={data.status} 
                            onChange={(e) => setData("status", e.target.value)}
                            required
                        >
                            <option value="available">Tersedia</option>
                            <option value="unavailable">Tidak Tersedia</option>
                        </select>
                        {errors.status && <p className="text-red-500 text-sm">{errors.status}</p>}
                    </div>

                    <div className="mt-2">
                        <input 
                            type="file" 
                            className="border p-2 rounded w-full" 
                            onChange={(e) => setData("image", e.target.files[0])}
                        />
                        {errors.image && <p className="text-red-500 text-sm">{errors.image}</p>}
                    </div>

                    {progress && (
                        <div className="w-full bg-gray-200 rounded h-2 mt-2">
                            <div className="bg-blue-500 h-2 rounded" style={{ width: `${progress.percentage}%` }}></div>
                        </div>
                    )}

                    <button 
                        type="submit" 
                        className="mt-4 bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
                    >
                        Simpan Perubahan
                    </button>
                </form>
            </div>
        </AdminLayout>
    );
}
