using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PositionLimiter : MonoBehaviour
{
    public Vector2 minMaxHorizontal;
    public Vector2 minMaxVertical;

    // Update is called once per frame
    public void Check()
    {
        var posX = transform.position.x;
        var posY = transform.position.y;
        var posZ = transform.position.z;

        if (posX > minMaxHorizontal.y)
        {
            posX = minMaxHorizontal.y;
        }
        else if (posX < minMaxHorizontal.x)
        {
            posX = minMaxHorizontal.x;
        }

        if (posY > minMaxVertical.y)
        {
            posY = minMaxVertical.y;
        }
        else if (posY < minMaxVertical.x)
        {
            posY = minMaxVertical.x;
        }

        transform.position = new Vector3(posX, posY, posZ);

    }
}
