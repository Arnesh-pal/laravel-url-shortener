<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>URL Shortener</title>
    
    {{-- Tailwind CSS from CDN --}}
    <script src="https://cdn.tailwindcss.com"></script>
    
    {{-- Google Font for a futuristic feel --}}
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap" rel="stylesheet">
    
    @livewireStyles
</head>
<body class="bg-gray-900 text-gray-200 font-['Inter'] antialiased">

    <div class="container mx-auto p-8">
        {{-- Main Title --}}
        <h1 class="text-4xl md:text-5xl font-bold text-center mb-8 text-cyan-400 tracking-wide">
            URL Shortener <span class="text-cyan-600">✂️</span>
        </h1>

        {{-- Form Section --}}
        <div class="bg-gray-800/50 border border-cyan-500/30 backdrop-blur-sm p-6 rounded-lg shadow-lg shadow-cyan-500/10 mb-8 max-w-2xl mx-auto">
            <form action="{{ route('shorten.url') }}" method="POST">
                @csrf
                <div class="flex items-center">
                    <input 
                        type="url" 
                        name="original_url" 
                        class="w-full p-3 bg-gray-900 text-gray-100 border border-gray-700 rounded-l-md focus:outline-none focus:ring-2 focus:ring-cyan-500 transition duration-300 placeholder-gray-500" 
                        placeholder="https://paste-your-long-url-here..."
                        required>
                    <button 
                        type="submit" 
                        class="bg-gradient-to-r from-cyan-500 to-blue-600 text-white p-3 rounded-r-md hover:from-cyan-400 hover:to-blue-500 font-bold transition-all duration-300 transform hover:scale-105">
                        Shorten
                    </button>
                </div>
                 @error('original_url')
                    <p class="text-red-400 text-sm mt-2">{{ $message }}</p>
                @enderror
            </form>

            @if (session('success'))
                <div class="bg-cyan-900/50 border border-cyan-600 text-cyan-200 px-4 py-3 rounded relative mt-4" role="alert">
                    <strong class="font-bold">Success!</strong>
                    <span class="block sm:inline">Your new short URL is ready.</span>
                </div>
            @endif
        </div>

        {{-- Render the Livewire component --}}
        <livewire:url-list />
        
    </div>

    @livewireScripts
</body>
</html>