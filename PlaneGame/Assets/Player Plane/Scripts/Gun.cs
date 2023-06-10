using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Gun : MonoBehaviour
{
    public GameObject bullet;
    public Transform bulletSpawn;
    public Vector2 minMaxHorizontalOffset;
    public Vector2 minMaxVerticalOffset;
    public float timeBetweenShots;
    private float _time;
    public KeyCode shootKey;

    private void Start()
    {
        _time = 0;
    }

    private void Update()
    {
        if (Input.GetKey(shootKey))
        {
            if (_time <= 0)
            {
                Instantiate(
                    bullet,
                    bulletSpawn.position + new Vector3(
                                            Random.Range(minMaxHorizontalOffset.x, minMaxHorizontalOffset.y),
                                            Random.Range(minMaxVerticalOffset.x, minMaxVerticalOffset.y),
                                            0),
                    bulletSpawn.rotation);
                _time = timeBetweenShots;
            }
            else
            {
                _time -= Time.deltaTime;
            }
        }
        else
        {
            _time = 0;
        }
    }
}
