using UnityEditor;

public class CreateAssetBundles
{
    [MenuItem ("Assets/Build MyAssetBundle")]
    static void BuildAllAssetBundles()
    {
        BuildPipeline.BuildAssetBundles("Assets/AssetBundles", BuildAssetBundleOptions.None, BuildTarget.StandaloneWindows);
    }
}
