using UnityEngine;
using UnityEditor;

[ExecuteInEditMode]
public class RotateObjectTest : MonoBehaviour
{
    [SerializeField] private float rotationSpeedX = 90f;
    [SerializeField] private float rotationSpeedY = 90f;
    [SerializeField] private float rotationSpeedZ = 90f;
    
    void Update() {
        if (!Application.isPlaying) {
            transform.Rotate(rotationSpeedX * Time.deltaTime, rotationSpeedY * Time.deltaTime, rotationSpeedZ * Time.deltaTime);
        }
    }
}
