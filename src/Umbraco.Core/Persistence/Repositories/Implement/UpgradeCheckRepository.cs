using System.Net.Http;
using System.Net.Http.Formatting;
using System.Threading.Tasks;
using Semver;
using Umbraco.Core.Models;

namespace Umbraco.Core.Persistence.Repositories.Implement
{
    internal class UpgradeCheckRepository : IUpgradeCheckRepository
    {
        private static HttpClient _httpClient;
        private const string RestApiUpgradeChecklUrl = "https://our.umbraco.com/umbraco/api/UpgradeCheck/CheckUpgrade";


        public async Task<UpgradeResult> CheckUpgradeAsync(SemVersion version)
        {
            // Update checking disabled for Lofcz.Forks.Umbraco fork
            // Official Umbraco updates don't apply to this fork
            return await Task.FromResult(new UpgradeResult("None", "", ""));
        }
        private class CheckUpgradeDto
        {
            public CheckUpgradeDto(SemVersion version)
            {
                VersionMajor = version.Major;
                VersionMinor = version.Minor;
                VersionPatch = version.Patch;
                VersionComment = version.Prerelease;
            }

            public int VersionMajor { get;  }
            public int VersionMinor { get; }
            public int VersionPatch { get; }
            public string VersionComment { get;  }
        }
    }
}
