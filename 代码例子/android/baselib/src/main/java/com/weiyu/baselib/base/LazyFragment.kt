package com.weiyu.baselib.base

import android.app.ProgressDialog
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.support.v4.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.view.inputmethod.InputMethodManager

abstract class LazyFragment : Fragment() {
    lateinit var inputMethodManager: InputMethodManager
    private var mContentLayoutResId: Int = 0
    var isVisibles: Boolean = false
    /**
     * 控件是否初始化完成
     */
    private var isViewCreated: Boolean = false

    internal var bar: ProgressDialog? = null
    /**
     * 缓存content布局
     */
    protected var contentView: View? = null

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        //        return super.onCreateView(inflater, container, savedInstanceState);
        if (null != contentView) {
            val parent = contentView!!.parent as ViewGroup
            if (null != parent) {
                parent!!.removeViewInLayout(contentView)
            }
        } else {
            mContentLayoutResId = getContentLayoutResId()
            if (0 == mContentLayoutResId) {
                throw IllegalArgumentException(
                    "mContentLayoutResId is 0, "
                            + "you must thought the method getContentLayoutResId() set the mContentLayoutResId's value"
                            + "when you used a fragment which implements the gta.dtp.fragment.BaseFragment."
                )
            }
            contentView = inflater.inflate(mContentLayoutResId, container, false)
            // 注解方式初始化控件
            initializeContentViews()
        }
        isViewCreated = true
        inputMethodManager = activity!!.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        return contentView
    }

    /**
     * 获取子类fragment布局资源id（作用等同于activity的setContentView（int resId）中指定的resId）
     */
    abstract fun getContentLayoutResId(): Int

    /**
     * 初始化具体子类布局资源里的views
     */
    abstract fun initializeContentViews()

    fun showBar() {
        bar!!.setMessage("加载中...")
        bar!!.show()
    }

    fun showBarCommit() {
        bar!!.setMessage("正在提交...")
        bar!!.show()
    }

    fun hideBar() {
        bar!!.dismiss()
    }

    fun startActivity(tClass: Class<*>) {
        startActivity(Intent(activity, tClass))
    }

    //获取屏幕的宽度
    fun getScreenWidth(context: Context): Int {
        val manager = context
            .getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val display = manager.defaultDisplay
        return display.width
    }

    //获取屏幕的高度
    fun getScreenHeight(context: Context): Int {
        val manager = context
            .getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val display = manager.defaultDisplay
        return display.height
    }

    protected fun hideSoftKeyboard() {
        if (activity!!.window.attributes.softInputMode != WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN) {
            if (activity!!.currentFocus != null)
                inputMethodManager.hideSoftInputFromWindow(
                    activity!!.currentFocus!!.windowToken,
                    InputMethodManager.HIDE_NOT_ALWAYS
                )
        }
    }

    /**
     * 在这里实现Fragment数据的缓加载.
     * @param isVisibleToUser
     */
    override fun setUserVisibleHint(isVisibleToUser: Boolean) {
        super.setUserVisibleHint(isVisibleToUser)
        if (userVisibleHint) {
            isVisibles = true
            onVisible()
        } else {
            isVisibles = false
            onInvisible()
        }
    }

    protected fun onVisible() {
        lazyLoad()
    }

    protected abstract fun lazyLoad()

    protected fun onInvisible() {}
}