<div class="bg-gray-800/50 border border-cyan-500/30 backdrop-blur-sm p-6 rounded-lg shadow-lg shadow-cyan-500/10" wire:poll> 
    <h2 class="text-2xl font-bold mb-4 text-gray-200">All Shortened URLs</h2>
    <div class="overflow-x-auto">
        <table class="min-w-full">
            <thead class="border-b border-gray-700">
                <tr>
                    <th class="py-3 px-4 text-left text-sm font-bold text-cyan-400 uppercase tracking-wider">Short URL</th>
                    <th class="py-3 px-4 text-left text-sm font-bold text-cyan-400 uppercase tracking-wider">Original URL</th>
                    <th class="py-3 px-4 text-center text-sm font-bold text-cyan-400 uppercase tracking-wider">Visits</th>
                </tr>
            </thead>
            <tbody>
                @forelse ($urls as $url)
                <tr class="border-b border-gray-800 hover:bg-gray-700/50 transition-colors duration-200">
                    <td class="py-4 px-4">
                        <a href="{{ url($url->short_code) }}" target="_blank" class="text-cyan-400 hover:text-cyan-300 font-medium">
                            {{ url($url->short_code) }}
                        </a>
                    </td>
                    <td class="py-4 px-4 text-sm text-gray-400 truncate" style="max-width: 400px;" title="{{ $url->original_url }}">
                        {{ $url->original_url }}
                    </td>
                    <td class="py-4 px-4 text-center font-bold text-lg text-white">{{ $url->visits }}</td>
                </tr>
                @empty
                <tr>
                    <td colspan="3" class="text-center py-8 text-gray-500">
                        No URLs have been shortened yet.
                    </td>
                </tr>
                @endforelse
            </tbody>
        </table>
    </div>
</div>