using System.Collections;
using System.Collections.Generic;
using RotaryHeart.Lib.SerializableDictionary;
using UnityEngine;
using System;
using Mirror;

namespace Core
{
    #region Interfaces

    public interface IResettable
    {
        void ServerReset();
    }
    
    public interface IShoutMessages
    {
        event Action<string> OnShoutMessage;
    }
    public interface IPooled
    {
        event Action<IPooled> OnReturnToPool;
    }

    public interface ICanDie
    {
        void Kill();
    }
    public interface INeedServerInitialisation
    {
        void InitialiseServer();
    }

    public interface INeedInstantFeedback
    {
        event Action OnNeedFeedback;
    }

    public interface INeedContinuousFeedbackX
    {
        float PowerX { get; }
    }
    public interface INeedContinuousFeedbackXY
    {
        float PowerX { get; }
        float PowerY { get; }
    }
    public interface INeedContinuousFeedbackXYZ
    {
        float PowerX { get; }
        float PowerY { get; }
        float PowerZ { get; }
    }

    /// <summary>
    /// implement this interface if a visual element needs to display a quantity in from thhis script.
    /// </summary>
    public interface IChangeQuantity
    {
        /// <summary>
        /// current quantity, max quantity
        /// </summary>
        event Action<short, short> OnChangeQuantity;
    }

    public interface INeedNetIdTarget
    {
        public uint TargetNetId
        {
            set;
        }
    }

    public interface ILinkToGo
    {
        public GameObject LinkedGo
        {
            get;
            set;
        }
    }
    #endregion

    #region Enums

    public enum PooledType : byte
    {
        bolt,
        explosive_shell,
        pistol_bolt,
    }

    #endregion


    #region Structs
    



    public struct PositionRotation
    {
        public Vector3 position;
        public Quaternion rotation;
    }

    #endregion


    #region Classes
    public static class MyUtils
    {
        
        #region Static methods
        public static bool StringToBool(string p_string)
        {
            if (p_string == "true")
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        public static string BoolToString(bool p_bool)
        {
            if (p_bool)
            {
                return "true";
            }
            else
            {
                return "false";
            }
        }
        public static float SquaredDistance(Vector3 a, Vector3 b)
        {
            float x = a.x - b.x;
            float y = a.y - b.y;
            float z = a.z - b.z;
            return x * x + y * y + z * z;
        }
        public static short CompressedFloat(float toCompress)
        {
            float multiplied = toCompress * 100;
            return (short)multiplied;
        }
        public static float DecompressedFloat(short toDecompress)
        {
            return (float)toDecompress / 100;
        }
        #endregion

    }

    [Serializable]
    public class TwoAxisRotator
    {
        public Transform horizontalRotator = null;
        public Transform pointer = null;
        [SerializeField] float resetCameraRotationSpeed = 120;

        public void RotateView()
        {
            if (InputsBlocker.instance.BlockPlayerInputs())
            {
                return;
            }

            if (horizontalRotator!=null)
            {
                RotateViewHorizontal();
            }
            
            
                RotateViewVertical();
            
            
        }
        /// <summary>
        /// gently rotate the view back to forward position
        /// </summary>
        public void GentlySnapForward()
        {
            if (horizontalRotator!=null)
            {
                SnapTransformForward(horizontalRotator);
            }
            
            SnapTransformForward(pointer);
        }
   

        void SnapTransformForward(Transform _transform)
        {
            _transform.localRotation = Quaternion.RotateTowards(_transform.localRotation, Quaternion.identity, resetCameraRotationSpeed * Time.deltaTime);
        }

        void RotateViewHorizontal()
        {
            float horizontal = Input.GetAxis("Mouse X")*KeyBindings.m_mouseSensitivity;

            horizontalRotator.transform.Rotate(0, horizontal, 0);

        }

        void RotateViewVertical()
        {
            float vertical = Input.GetAxis("Mouse Y")*KeyBindings.m_mouseSensitivity;

            pointer.Rotate(-vertical, 0, 0);

            float angle = Vector3.SignedAngle(horizontalRotator.transform.forward, pointer.forward, horizontalRotator.transform.right);


            if (angle > 75)
            {
                pointer.localRotation = Quaternion.Euler(75, 0, 0);
            }
            if (angle < -75)
            {
                pointer.localRotation = Quaternion.Euler(-75, 0, 0);
            }

        }
    }

    [Serializable]
    public class Pool
    {
        public GameObject pooledPrefab = null;
        public int poolSize = 10;
        public Queue<IPooled> pooledQueue = new Queue<IPooled>();
        public void FillQueue()
        {

        }

        public GameObject GetProjectileFromPool()
        {
            if (pooledQueue.Count == 0)
            {
                AddNewObjectToPool();
            }
            IPooled pooled = pooledQueue.Dequeue();
            if(pooled is Component component)
            {
                component.gameObject.SetActive(true);
                return component.gameObject;
            }


            return null;
            
        }

        void AddNewObjectToPool()
        {
            GameObject instanciedObject = GameObject.Instantiate(pooledPrefab);
            IPooled pooled = instanciedObject.GetComponent<IPooled>();
            pooled.OnReturnToPool += ReturnToPool;
            pooledQueue.Enqueue(pooled);
            instanciedObject.SetActive(false);
        }

        void ReturnToPool(IPooled pooled)
        {
            pooledQueue.Enqueue(pooled);
            if(pooled is Component component)
            {
                component.gameObject.SetActive(false);
            }
        }
    }

    public class MousePullController
    {
        public static float maxSize=150f;
        Vector2 dotPosition=Vector2.zero;


        public void CalculateCurrentInput()
        {            
            dotPosition.x += Input.GetAxis("Mouse X");
            dotPosition.y += Input.GetAxis("Mouse Y");

            if (dotPosition.magnitude > maxSize)
            {
                dotPosition = Vector2.ClampMagnitude(dotPosition, maxSize);
            }

            
        }

        public Vector2 CurrentInput
        {
            get
            {
                Vector2 currentInput = new Vector2 { x = dotPosition.x / maxSize, y = dotPosition.y / maxSize };

                return currentInput;
            }
        }
        public void ResetMiddle()
        {
            dotPosition = Vector2.zero;
        }


    }

    [Serializable]
    public class SerialisablePoolDictionnary : SerializableDictionaryBase<PooledType, Pool> { }


    #endregion
}


